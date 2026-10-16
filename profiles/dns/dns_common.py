"""Shared CLI, command, locking, and WiFi-session helpers."""

import argparse
from contextlib import contextmanager
import fcntl
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
        command.add_argument("uuid", nargs="?", help="expected WiFi session UUID")
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
    return iface, connection_uuid(iface)


def connection_uuid(iface):
    return output("nmcli", "-g", "GENERAL.CON-UUID", "device", "show", iface)


def same_session(iface, uuid):
    result = run(
        "nmcli", "-g", "GENERAL.CON-UUID", "device", "show", iface,
        capture=True, check=False, quiet=True,
    )
    return result.returncode == 0 and result.stdout.strip() == uuid


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
