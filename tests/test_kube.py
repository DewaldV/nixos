"""Exercise the Zsh helper with real kubectl and isolated, offline kubeconfigs."""

import json
import os
from pathlib import Path
import shutil
import subprocess
from tempfile import TemporaryDirectory
import unittest


HELPERS = Path(__file__).resolve().parents[1] / "profiles/shell/zsh/zsh-custom/kube.zsh"
TEMP_ROOT = "/tmp/opencode" if Path("/tmp/opencode").is_dir() else None


def kubeconfig(contexts, *, extra_clusters=(), extra_users=()):
    clusters = {cluster for _, cluster, _ in contexts if cluster} | set(extra_clusters)
    users = {user for _, _, user in contexts if user} | set(extra_users)
    return {
        "apiVersion": "v1",
        "kind": "Config",
        "current-context": contexts[-1][0],
        "clusters": [
            {"name": name, "cluster": {"server": "https://127.0.0.1:9"}}
            for name in sorted(clusters)
        ],
        "users": [{"name": name, "user": {"token": "test-token"}} for name in sorted(users)],
        "contexts": [
            {"name": name, "context": {"cluster": cluster, **({"user": user} if user else {})}}
            for name, cluster, user in contexts
        ],
    }


class KubeCleanupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        missing = [name for name in ("zsh", "jq", "kubectl") if not shutil.which(name)]
        if missing:
            raise RuntimeError(f"Missing test dependencies: {', '.join(missing)}")

    def setUp(self):
        self.directory = TemporaryDirectory(dir=TEMP_ROOT)
        self.addCleanup(self.directory.cleanup)
        self.path = Path(self.directory.name) / "config"
        self.env = {
            **os.environ,
            "HOME": self.directory.name,
            "ZDOTDIR": self.directory.name,
            "KUBECONFIG": str(self.path),
        }

    def write(self, contexts, **kwargs):
        self.path.write_text(json.dumps(kubeconfig(contexts, **kwargs)))

    def run_helper(self, *args, fail="", prefix=""):
        script = '''
            source "$1"
            shift
            kubectl() {
                if [[ -n "$FAIL_COMMAND" && "$2" == "$FAIL_COMMAND" ]]; then
                    return 23
                fi
                command kubectl "$@"
            }
        ''' + prefix + '\nkcdel "$@"'
        return subprocess.run(
            ["zsh", "-f", "-c", script, "kcdel-test", str(HELPERS), *args],
            env={**self.env, "FAIL_COMMAND": fail}, text=True, capture_output=True,
        )

    def names(self):
        result = subprocess.run(
            ["kubectl", "config", "view", "-o", "json"],
            env=self.env, check=True, text=True, capture_output=True,
        )
        config = json.loads(result.stdout)
        return {
            kind: {item["name"] for item in (config.get(kind) or [])}
            for kind in ("contexts", "clusters", "users")
        }

    def test_uses_exact_context_references_instead_of_matching_names(self):
        self.write(
            [("prod", "production-cluster", "production-user"), ("prod-old", "old-cluster", "old-user")],
            extra_clusters=["prod"], extra_users=["prod"],
        )
        result = self.run_helper("prod")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.names(), {
            "contexts": {"prod-old"},
            "clusters": {"prod", "old-cluster"},
            "users": {"prod", "old-user"},
        })

    def test_preserves_shared_cluster_and_user_references_independently(self):
        for share_cluster, share_user in ((True, True), (True, False), (False, True)):
            with self.subTest(cluster=share_cluster, user=share_user):
                self.write([
                    ("remove", "cluster", "user"),
                    ("keep", "cluster" if share_cluster else "other-cluster", "user" if share_user else "other-user"),
                ])
                result = self.run_helper("remove")
                self.assertEqual(result.returncode, 0, result.stderr)
                names = self.names()
                self.assertEqual(names["contexts"], {"keep"})
                self.assertEqual("cluster" in names["clusters"], share_cluster)
                self.assertEqual("user" in names["users"], share_user)

    def test_literal_names_with_spaces_metacharacters_and_leading_dashes(self):
        for name in ("prod [1].* team", "--prod"):
            with self.subTest(name=name):
                self.write([(name, "--cluster", "--user")])
                result = self.run_helper(name)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(self.names(), {"contexts": set(), "clusters": set(), "users": set()})

    def test_anonymous_context_does_not_delete_unrelated_users(self):
        self.write([("anonymous", "cluster", None)], extra_users=["keep-user"])
        result = self.run_helper("anonymous")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.names()["users"], {"keep-user"})

    def test_missing_context_and_invalid_arguments_do_not_modify_config(self):
        self.write([("prod", "cluster", "user")])
        original = self.path.read_bytes()
        for args in ((), ("",), ("pro",), ("prod", "extra")):
            with self.subTest(args=args):
                self.assertNotEqual(self.run_helper(*args).returncode, 0)
                self.assertEqual(self.path.read_bytes(), original)

    def test_failed_read_or_context_deletion_does_not_delete_references(self):
        self.write([("prod", "cluster", "user")])
        original = self.path.read_bytes()
        for command in ("view", "delete-context"):
            with self.subTest(command=command):
                self.assertEqual(self.run_helper("prod", fail=command).returncode, 23)
                self.assertEqual(self.path.read_bytes(), original)

    def test_failed_cluster_deletion_stops_before_deleting_user(self):
        self.write([("prod", "cluster", "user")])
        self.assertEqual(self.run_helper("prod", fail="delete-cluster").returncode, 23)
        self.assertEqual(self.names(), {
            "contexts": set(), "clusters": {"cluster"}, "users": {"user"},
        })

    def test_references_in_other_kubeconfig_files_are_preserved(self):
        self.write([("remove", "cluster", "user")])
        other = Path(self.directory.name) / "other-config"
        other.write_text(json.dumps(kubeconfig([("keep", "cluster", "user")])))
        self.env["KUBECONFIG"] = os.pathsep.join((str(self.path), str(other)))
        result = self.run_helper("remove")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.names(), {
            "contexts": {"keep"}, "clusters": {"cluster"}, "users": {"user"},
        })

    def test_rechecks_references_after_context_deletion(self):
        self.write([("remove", "cluster", "user")])
        result = self.run_helper("remove", prefix='''
            kubectl() {
                command kubectl "$@" || return
                if [[ "$2" == delete-context ]]; then
                    command kubectl config set-context added --cluster cluster --user user
                fi
            }
        ''')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.names(), {
            "contexts": {"added"}, "clusters": {"cluster"}, "users": {"user"},
        })


if __name__ == "__main__":
    unittest.main()
