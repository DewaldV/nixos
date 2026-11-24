"""Shared CLI, command, locking, and WiFi-session helpers."""

import argparse
from contextlib import contextmanager
import fcntl
import json
import os
import subprocess
import sys


class PolicyError(Exception):
    pass


def parse_args(*, policy=False):
    parser = argparse.ArgumentParser(
        prog="roaming-dns-policy" if policy else "captive-portal",
        description="Manage runtime DNS policy and temporary captive-portal mode.",
    )
    commands = parser.add_subparsers(dest="action")
    commands.add_parser("status", help="show portal mode and resolver status (default)")
    for action, help_text in (
        ("on", "enable network-provided DNS for captive-portal sign-in"),
        ("off", "restore secure Quad9 DNS"),
    ):
        command = commands.add_parser(action, help=help_text)
        command.add_argument("session", nargs="?", help="expected NetworkManager activation token")
    if policy:
        command = commands.add_parser("event", help="handle a NetworkManager dispatcher event")
        command.add_argument("interface")
        command.add_argument("event")
    else:
        commands.add_parser("open", help="sign in using a disposable Firefox profile")
    parser.set_defaults(action="status")
    return parser.parse_args()


def run(*args, capture=False, check=True, quiet=False):
    return subprocess.run(
        args,
        check=check,
        text=True,
        stdout=subprocess.PIPE if capture else None,
        stderr=subprocess.DEVNULL if quiet else None,
        env={**os.environ, "LC_ALL": "C"},
    )


def output(*args):
    return run(*args, capture=True).stdout.strip()


def wifi_session():
    interfaces = []
    for line in output("nmcli", "-t", "-f", "DEVICE,TYPE,STATE", "device", "status").splitlines():
        device, kind, state = line.rsplit(":", 2)
        if kind == "wifi" and state == "connected":
            interfaces.append(device)
    if len(interfaces) != 1:
        raise PolicyError("Expected exactly one connected WiFi interface.")
    iface = interfaces[0]
    return iface, connection_session(iface)


def connection_session(iface):
    # The active-connection path changes on reconnect; the bus owner changes
    # when NetworkManager restarts, even if it reuses an object path.
    owner = run(
        "busctl", "--system", "--json=short", "call",
        "org.freedesktop.DBus", "/org/freedesktop/DBus",
        "org.freedesktop.DBus", "GetNameOwner", "s", "org.freedesktop.NetworkManager",
        capture=True, quiet=True,
    )
    path = run(
        "nmcli", "-g", "GENERAL.CON-PATH", "device", "show", iface,
        capture=True, quiet=True,
    ).stdout.strip()
    if not path.startswith("/org/freedesktop/NetworkManager/ActiveConnection/"):
        raise PolicyError(f"No active connection on {iface}.")
    return f"{json.loads(owner.stdout)['data'][0]}:{path}"


def same_session(iface, session):
    try:
        return connection_session(iface) == session
    except (PolicyError, OSError, subprocess.CalledProcessError):
        return False


@contextmanager
def lock(path, *, blocking=True):
    with path.open("w") as handle:
        try:
            fcntl.flock(handle, fcntl.LOCK_EX | (0 if blocking else fcntl.LOCK_NB))
        except BlockingIOError:
            raise PolicyError("A captive-portal browser workflow is already running.") from None
        yield


def cli(main):
    try:
        return main()
    except (PolicyError, OSError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1
