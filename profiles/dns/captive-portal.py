"""Disposable browser workflow for signing into a WiFi captive portal."""

import json
import os
from pathlib import Path
import signal
import subprocess
import sys
from tempfile import TemporaryDirectory
import time

from dns_common import PolicyError, cli, lock, parse_args, run, same_session, wifi_session


POLICY = str(Path(__file__).resolve().parent.parent / "bin/roaming-dns-policy")
PREFERENCES = {
    "network.trr.mode": 5,
    "dom.security.https_only_mode": False,
    "dom.security.https_only_mode_pbm": False,
    "dom.security.https_first": False,
    "dom.security.https_first_pbm": False,
    "network.captive-portal-service.enabled": False,
    "browser.shell.checkDefaultBrowser": False,
    "browser.startup.homepage_override.mstone": "ignore",
    "datareporting.policy.dataSubmissionEnabled": False,
}


def change_mode(action, expected_uuid=None):
    args = ["/run/wrappers/bin/pkexec", POLICY, action]
    if expected_uuid is not None:
        args.append(expected_uuid)
    run(*args)


def interrupted(signum, frame):
    raise SystemExit(128 + signum)


def online(iface):
    # Keep curl's interface binding and TLS validation; redirects are not success.
    result = run(
        "curl", "--silent", "--show-error", "--noproxy", "*", "--interface", iface,
        "--connect-timeout", "5", "--max-time", "10", "--output", "/dev/null",
        "--write-out", "%{http_code}",
        "https://connectivitycheck.gstatic.com/generate_204",
        capture=True, check=False,
    )
    return result.returncode == 0 and result.stdout == "204"


def open_portal():
    iface, uuid = wifi_session()
    portal_enabled = False
    browser = None
    # Use the system resolver and allow HTTP portal redirects.
    with TemporaryDirectory(prefix="captive-portal-firefox.") as profile:
        prefs = "".join(f"user_pref({json.dumps(key)}, {json.dumps(value)});\n" for key, value in PREFERENCES.items())
        Path(profile, "user.js").write_text(prefs)
        try:
            change_mode("on", uuid)
            portal_enabled = True
            print("Sign in through the portal, then close this Firefox instance.", flush=True)
            browser = subprocess.Popen([
                "firefox", "--no-remote", "--new-instance", "--profile", profile,
                "http://neverssl.com",
            ])
            result = browser.wait()
            if result:
                raise PolicyError(f"Firefox exited with status {result}.")
            print("Browser closed. Waiting for Internet connectivity (Ctrl+C to cancel).", flush=True)
            while same_session(iface, uuid):
                if online(iface):
                    change_mode("off", uuid)
                    portal_enabled = False
                    print("Internet connectivity confirmed; secure DNS restored.")
                    return 0
                print("Not online yet; retrying in 3 seconds.", flush=True)
                time.sleep(3)
            # The dispatcher already resets portal mode on disconnect/reconnect.
            portal_enabled = False
            raise PolicyError("WiFi session changed; stopping the captive-portal workflow.")
        finally:
            if browser is not None and browser.poll() is None:
                browser.terminate()
                try:
                    browser.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    browser.kill()
                    browser.wait()
            if portal_enabled and same_session(iface, uuid):
                print("Restoring secure DNS before exiting.", flush=True)
                change_mode("off", uuid)


def main():
    args = parse_args()
    if args.action == "status":
        return run(POLICY, "status", check=False).returncode
    if args.action in {"on", "off"}:
        change_mode(args.action, args.uuid)
        return 0
    runtime_dir = os.environ.get("XDG_RUNTIME_DIR")
    if not runtime_dir:
        raise PolicyError("Missing XDG_RUNTIME_DIR")
    signal.signal(signal.SIGINT, interrupted)
    signal.signal(signal.SIGTERM, interrupted)
    with lock(Path(runtime_dir) / "captive-portal-open.lock", blocking=False):
        return open_portal()


if __name__ == "__main__":
    sys.exit(cli(main))
