"""DNS-policy regressions with mocked commands; never change host networking."""

from contextlib import ExitStack, redirect_stdout
import importlib.util
import io
import json
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import unittest
from unittest.mock import Mock, patch


DNS = Path(__file__).resolve().parents[1] / "profiles/dns"
sys.path.insert(0, str(DNS))
import dns_common as common


def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, DNS / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


policy = load("roaming_dns", "roaming-dns.py")
portal = load("captive_portal", "captive-portal.py")
ACTIVE_PATH = "/org/freedesktop/NetworkManager/ActiveConnection/1"
SESSION = f":1.10:{ACTIVE_PATH}"
NEXT_SESSION = SESSION[:-1] + "2"
TEMP_ROOT = "/tmp/opencode" if Path("/tmp/opencode").is_dir() else None


class SessionTests(unittest.TestCase):
    def setUp(self):
        self.owner = ":1.10"
        self.path = ACTIVE_PATH

        def run(*args, **kwargs):
            if args[0] == "busctl":
                value = json.dumps({"type": "s", "data": [self.owner]})
            else:
                self.assertEqual(args[2], "GENERAL.CON-PATH")
                value = self.path
            return SimpleNamespace(stdout=value, returncode=0)

        patcher = patch.object(common, "run", side_effect=run)
        self.command = patcher.start()
        self.addCleanup(patcher.stop)

    def test_reconnect_to_same_profile_is_a_new_session(self):
        session = common.connection_session("wlan0")
        self.assertTrue(common.same_session("wlan0", session))
        self.path = ACTIVE_PATH[:-1] + "2"
        self.assertFalse(common.same_session("wlan0", session))

    def test_daemon_restart_cannot_reuse_a_session_token(self):
        session = common.connection_session("wlan0")
        self.owner = ":1.20"
        self.assertFalse(common.same_session("wlan0", session))

    def test_disconnected_interface_is_not_a_session(self):
        self.path = "--"
        self.assertFalse(common.same_session("wlan0", SESSION))
        with self.assertRaises(common.PolicyError):
            common.connection_session("wlan0")

    def test_unavailable_networkmanager_is_not_a_matching_session(self):
        self.command.side_effect = subprocess.CalledProcessError(1, ["busctl"])
        self.assertFalse(common.same_session("wlan0", SESSION))


class PolicyTests(unittest.TestCase):
    def setUp(self):
        self.stack = ExitStack()
        self.addCleanup(self.stack.close)
        self.directory = Path(self.stack.enter_context(TemporaryDirectory(dir=TEMP_ROOT)))
        self.marker = self.directory / "wlan0"
        self.current_session = SESSION
        self.secure = {
            "dnsovertls": ("yes",),
            "dnssec": ("yes",),
            "dns": policy.QUAD9,
            "domain": ("",),
            "default-route": ("yes",),
        }
        self.settings = dict(self.secure)
        self.fail = lambda args: False
        self.after_command = lambda args: None

        def run(*args):
            self.assertEqual(args[0], "resolvectl")
            if self.fail(args):
                raise subprocess.CalledProcessError(1, args)
            if args[1] != "flush-caches":
                self.settings[args[1]] = args[3:]
            self.after_command(args)

        def output(*args):
            if "GENERAL.TYPE" in args:
                return "wifi"
            if "IP4.DNS,IP6.DNS" in args:
                return "192.0.2.53|2001:db8::53"
            return ""

        self.stack.enter_context(redirect_stdout(io.StringIO()))
        self.stack.enter_context(patch.object(policy, "STATE", self.directory))
        self.stack.enter_context(patch.object(policy, "wifi_session", side_effect=lambda: ("wlan0", self.current_session)))
        self.stack.enter_context(patch.object(policy, "connection_session", side_effect=lambda _: self.current_session))
        self.stack.enter_context(patch.object(policy, "same_session", side_effect=lambda _, session: session == self.current_session))
        self.stack.enter_context(patch.object(policy, "output", side_effect=output))
        self.command = self.stack.enter_context(patch.object(policy, "run", side_effect=run))

    def fail_once(self, name):
        def fail(args):
            if args[1] == name:
                self.fail = lambda _: False
                return True
            return False
        self.fail = fail

    def test_each_partial_setup_failure_restores_secure_dns(self):
        for name in (*self.secure, "flush-caches"):
            with self.subTest(command=name):
                self.fail_once(name)
                with self.assertRaises(subprocess.CalledProcessError):
                    policy.change_mode("on", SESSION)
                self.assertEqual(self.settings, self.secure)
                self.assertFalse(self.marker.exists())

    def test_marker_write_failure_also_rolls_back_dns(self):
        with patch.object(Path, "write_text", side_effect=OSError("disk full")):
            with self.assertRaises(OSError):
                policy.change_mode("on", SESSION)
        self.assertEqual(self.settings, self.secure)
        self.assertFalse(self.marker.exists())

    def test_marker_cleanup_failure_does_not_prevent_restoring_dns(self):
        policy.change_mode("on", SESSION)
        with patch.object(Path, "unlink", side_effect=OSError("read-only state")):
            with self.assertRaises(OSError):
                policy.change_mode("off", SESSION)
        self.assertEqual(self.settings, self.secure)

    def test_interrupted_policy_update_rolls_back_before_propagating(self):
        def interrupt(args):
            if args[1] == "dns":
                self.after_command = lambda _: None
                raise KeyboardInterrupt
        self.after_command = interrupt
        with self.assertRaises(KeyboardInterrupt):
            policy.change_mode("on", SESSION)
        self.assertEqual(self.settings, self.secure)
        self.assertFalse(self.marker.exists())

    def test_failed_rollback_reports_error_and_attempts_remaining_settings(self):
        self.fail = lambda args: (
            args[1:4] == ("dns", "wlan0", "192.0.2.53")
            or args[1:] == ("dnsovertls", "wlan0", "yes")
        )
        with self.assertRaisesRegex(common.PolicyError, "restoring secure DNS also failed"):
            policy.change_mode("on", SESSION)
        self.assertEqual(self.settings["dnsovertls"], ("no",))
        for name in ("dnssec", "dns", "domain", "default-route"):
            self.assertEqual(self.settings[name], self.secure[name])
        self.assertIn((("resolvectl", "flush-caches"),), self.command.call_args_list)
        self.assertFalse(self.marker.exists())

    def test_dhcp_update_preserves_portal_mode_for_same_activation(self):
        policy.change_mode("on", SESSION)
        policy.event("wlan0", "dhcp4-change")
        self.assertEqual(self.marker.read_text().strip(), SESSION)
        self.assertEqual(self.settings["dnsovertls"], ("no",))
        self.assertEqual(self.settings["dns"], ("192.0.2.53", "2001:db8::53"))

    def test_failed_dhcp_reapply_clears_portal_mode(self):
        policy.change_mode("on", SESSION)
        self.fail_once("dns")
        with self.assertRaises(subprocess.CalledProcessError):
            policy.event("wlan0", "dhcp4-change")
        self.assertEqual(self.settings, self.secure)
        self.assertFalse(self.marker.exists())

    def test_off_rejects_old_activation_without_touching_new_marker(self):
        self.current_session = NEXT_SESSION
        self.marker.write_text(NEXT_SESSION + "\n")
        with self.assertRaises(common.PolicyError):
            policy.change_mode("off", SESSION)
        self.command.assert_not_called()
        self.assertEqual(self.marker.read_text().strip(), NEXT_SESSION)

    def test_reconnect_during_update_stops_further_changes_and_rollback(self):
        def reconnect(args):
            self.current_session = NEXT_SESSION
            self.marker.write_text(NEXT_SESSION + "\n")
        self.after_command = reconnect
        with self.assertRaises(common.PolicyError):
            policy.change_mode("on", SESSION)
        self.assertEqual(self.command.call_count, 1)
        self.assertEqual(self.marker.read_text().strip(), NEXT_SESSION)

    def test_old_activation_marker_cannot_reenable_portal_mode(self):
        policy.change_mode("on", SESSION)
        self.current_session = NEXT_SESSION
        policy.event("wlan0", "reapply")
        self.assertEqual(self.settings, self.secure)
        self.assertFalse(self.marker.exists())


class BrowserTests(unittest.TestCase):
    def setUp(self):
        self.stack = ExitStack()
        self.addCleanup(self.stack.close)
        self.current_session = SESSION
        self.stack.enter_context(redirect_stdout(io.StringIO()))
        self.stack.enter_context(patch.object(portal, "TemporaryDirectory", side_effect=lambda **kwargs: TemporaryDirectory(dir=TEMP_ROOT, **kwargs)))
        self.stack.enter_context(patch.object(portal, "wifi_session", return_value=("wlan0", SESSION)))
        self.stack.enter_context(patch.object(portal, "same_session", side_effect=lambda _, session: session == self.current_session))
        self.mode = self.stack.enter_context(patch.object(portal, "change_mode"))
        self.browser = Mock()
        self.browser.wait.return_value = 0
        self.browser.poll.return_value = 0
        self.launch = self.stack.enter_context(patch.object(portal.subprocess, "Popen", return_value=self.browser))
        self.stack.enter_context(patch.object(portal, "online", return_value=True))

    def actions(self):
        return [call.args for call in self.mode.call_args_list]

    def test_failed_enable_still_requests_cleanup(self):
        self.mode.side_effect = [subprocess.CalledProcessError(1, ["policy"]), None]
        with self.assertRaises(subprocess.CalledProcessError):
            portal.open_portal()
        self.assertEqual(self.actions(), [("on", SESSION), ("off", SESSION)])
        self.launch.assert_not_called()

    def test_interrupted_enable_still_requests_cleanup(self):
        self.mode.side_effect = [SystemExit(130), None]
        with self.assertRaises(SystemExit):
            portal.open_portal()
        self.assertEqual(self.actions(), [("on", SESSION), ("off", SESSION)])

    def test_browser_launch_failure_restores_dns(self):
        self.launch.side_effect = OSError("browser failed")
        with self.assertRaises(OSError):
            portal.open_portal()
        self.assertEqual(self.actions(), [("on", SESSION), ("off", SESSION)])

    def test_reconnect_while_browser_open_does_not_modify_new_connection(self):
        def close_browser():
            self.current_session = NEXT_SESSION
            return 0
        self.browser.wait.side_effect = close_browser
        with self.assertRaisesRegex(common.PolicyError, "WiFi session changed"):
            portal.open_portal()
        self.assertEqual(self.actions(), [("on", SESSION)])

    def test_successful_workflow_restores_dns_once(self):
        self.assertEqual(portal.open_portal(), 0)
        self.assertEqual(self.actions(), [("on", SESSION), ("off", SESSION)])


if __name__ == "__main__":
    unittest.main()
