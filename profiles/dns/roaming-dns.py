"""Runtime-only resolver policy; never change saved NetworkManager profiles."""

import os
from pathlib import Path
import re
import subprocess
import sys

from dns_common import (
    PolicyError, cli, connection_session, lock, output, parse_args, run, same_session, wifi_session,
)


STATE = Path("/run/captive-portal")
EVENTS = {"up", "vpn-up", "down", "vpn-down", "dhcp4-change", "dhcp6-change", "reapply"}
QUAD9 = (
    "9.9.9.9#dns.quad9.net", "149.112.112.112#dns.quad9.net",
    "2620:fe::fe#dns.quad9.net", "2620:fe::9#dns.quad9.net",
)


def markers():
    return sorted(path for path in STATE.glob("*") if path.is_file())


def require_session(iface, session):
    if not same_session(iface, session):
        raise PolicyError("The WiFi session changed; stopping the DNS policy update.")


def configure_wifi(iface, session, *, portal=False):
    marker = STATE / iface
    require_session(iface, session)
    errors = []
    if not portal:
        # A failed restore must not make a later DHCP event re-enable portal mode.
        try:
            marker.unlink(missing_ok=True)
        except OSError as error:
            errors.append(error)
    try:
        servers = QUAD9
        if portal:
            servers = output("nmcli", "--escape", "no", "-g", "IP4.DNS,IP6.DNS", "device", "show", iface)
            servers = servers.replace("|", " ").split()
            if not servers:
                raise PolicyError(f"No network-provided DNS servers on {iface}.")
        commands = [
            ("dnsovertls", iface, "no" if portal else "yes"),
            ("dnssec", iface, "no" if portal else "yes"),
            ("dns", iface, *servers),
            # Only portal mode gets a catch-all; Proton's ~. must beat secure WiFi.
            ("domain", iface, "~." if portal else ""),
            ("default-route", iface, "yes"),
            ("flush-caches",),
        ]
        for command in commands:
            require_session(iface, session)
            try:
                run("resolvectl", *command)
            except (OSError, subprocess.CalledProcessError) as error:
                if portal:
                    raise
                # Try every secure setting even if an earlier restore step fails.
                errors.append(error)
        if errors:
            raise errors[0]
        if portal:
            require_session(iface, session)
            marker.write_text(session + "\n")
    except (PolicyError, OSError, subprocess.CalledProcessError, KeyboardInterrupt) as error:
        if portal and same_session(iface, session):
            try:
                configure_wifi(iface, session)
            except (PolicyError, OSError, subprocess.CalledProcessError) as rollback_error:
                raise PolicyError(
                    f"Captive-portal update failed ({error}); "
                    f"restoring secure DNS also failed ({rollback_error})."
                ) from error
        raise


def change_mode(action, expected_session=None):
    iface, session = wifi_session()
    if expected_session is not None and expected_session != session:
        raise PolicyError("The WiFi session changed; DNS policy was not modified.")
    if action == "on":
        connections = output("nmcli", "-t", "-f", "NAME,DEVICE", "connection", "show", "--active")
        if re.search(r"(^ProtonVPN |:proton[0-9]+$|^pvpn-killswitch)", connections, re.MULTILINE):
            raise PolicyError("Disconnect Proton and disable its kill switch before enabling captive-portal mode.")
        configure_wifi(iface, session, portal=True)
        print(f"Captive-portal mode enabled on {iface}. Restore with: captive-portal off")
    else:
        configure_wifi(iface, session)
        print(f"Secure DNS restored on {iface}.")


def event(iface, name):
    if not re.fullmatch(r"[a-zA-Z0-9_.:-]+", iface) or iface in {".", ".."}:
        raise PolicyError("Invalid interface.")
    marker = STATE / iface
    if name in {"down", "vpn-down"}:
        marker.unlink(missing_ok=True)
        run("resolvectl", "flush-caches")
        return
    if name in {"up", "vpn-up"}:
        marker.unlink(missing_ok=True)
    if re.fullmatch(r"proton[0-9]+", iface) or os.environ.get("CONNECTION_ID", "").startswith("ProtonVPN "):
        run("resolvectl", "dnsovertls", iface, "no")
        run("resolvectl", "dnssec", iface, "yes")
        # End portal mode so two ~. links cannot share queries.
        for portal_marker in markers():
            session = portal_marker.read_text().strip()
            if same_session(portal_marker.name, session):
                configure_wifi(portal_marker.name, session)
            else:
                portal_marker.unlink(missing_ok=True)
        run("resolvectl", "flush-caches")
    elif output("nmcli", "-g", "GENERAL.TYPE", "device", "show", iface) == "wifi":
        session = connection_session(iface)
        portal = marker.is_file() and marker.read_text().strip() == session
        if not portal:
            marker.unlink(missing_ok=True)
        configure_wifi(iface, session, portal=portal)


def main():
    args = parse_args(policy=True)
    # Global dispatcher events have no interface and need no root access.
    if args.action == "event" and args.event not in EVENTS:
        return 0
    if args.action == "status":
        active = markers()
        for marker in active:
            print(f"Captive-portal mode enabled on {marker.name}", flush=True)
        if not active:
            print("Captive-portal mode disabled.", flush=True)
        run("resolvectl", "status")
        return 0
    if os.geteuid() != 0:
        raise PolicyError("DNS policy changes require root.")
    STATE.mkdir(mode=0o755, exist_ok=True)
    with lock(Path("/run/roaming-dns.lock")):
        if args.action == "event":
            event(args.interface, args.event)
        else:
            change_mode(args.action, args.session)
    return 0


if __name__ == "__main__":
    sys.exit(cli(main))
