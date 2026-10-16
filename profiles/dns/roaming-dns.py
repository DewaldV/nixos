"""Runtime-only resolver policy; never change saved NetworkManager profiles."""

import os
from pathlib import Path
import re
import sys

from dns_common import PolicyError, cli, connection_uuid, lock, output, parse_args, run, wifi_session


STATE = Path("/run/captive-portal")
EVENTS = {"up", "vpn-up", "down", "vpn-down", "dhcp4-change", "dhcp6-change", "reapply"}
QUAD9 = (
    "9.9.9.9#dns.quad9.net", "149.112.112.112#dns.quad9.net",
    "2620:fe::fe#dns.quad9.net", "2620:fe::9#dns.quad9.net",
)


def markers():
    return sorted(path for path in STATE.glob("*") if path.is_file())


def configure_wifi(iface, *, portal=False):
    servers = QUAD9
    if portal:
        servers = output("nmcli", "--escape", "no", "-g", "IP4.DNS,IP6.DNS", "device", "show", iface)
        servers = servers.replace("|", " ").split()
        if not servers:
            raise PolicyError(f"No network-provided DNS servers on {iface}.")
    run("resolvectl", "dnsovertls", iface, "no" if portal else "yes")
    run("resolvectl", "dnssec", iface, "no" if portal else "yes")
    run("resolvectl", "dns", iface, *servers)
    # Only portal mode gets a catch-all; Proton's ~. must beat secure WiFi.
    run("resolvectl", "domain", iface, "~." if portal else "")
    run("resolvectl", "default-route", iface, "yes")


def change_mode(action, expected_uuid=None):
    iface, uuid = wifi_session()
    if expected_uuid and expected_uuid != uuid:
        raise PolicyError("The WiFi session changed; DNS policy was not modified.")
    marker = STATE / iface
    if action == "on":
        connections = output("nmcli", "-t", "-f", "NAME,DEVICE", "connection", "show", "--active")
        if re.search(r"(^ProtonVPN |:proton[0-9]+$|^pvpn-killswitch)", connections, re.MULTILINE):
            raise PolicyError("Disconnect Proton and disable its kill switch before enabling captive-portal mode.")
        configure_wifi(iface, portal=True)
        marker.write_text(uuid + "\n")
        print(f"Captive-portal mode enabled on {iface}. Restore with: captive-portal off")
    else:
        configure_wifi(iface)
        marker.unlink(missing_ok=True)
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
            state = run(
                "nmcli", "-g", "GENERAL.STATE", "device", "show", portal_marker.name,
                capture=True, check=False, quiet=True,
            )
            if state.returncode == 0 and state.stdout.startswith("100"):
                configure_wifi(portal_marker.name)
            portal_marker.unlink()
    elif output("nmcli", "-g", "GENERAL.TYPE", "device", "show", iface) == "wifi":
        uuid = connection_uuid(iface)
        portal = marker.is_file() and marker.read_text().strip() == uuid
        if not portal:
            marker.unlink(missing_ok=True)
        configure_wifi(iface, portal=portal)
    else:
        return
    run("resolvectl", "flush-caches")


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
            change_mode(args.action, args.uuid)
            run("resolvectl", "flush-caches")
    return 0


if __name__ == "__main__":
    sys.exit(cli(main))
