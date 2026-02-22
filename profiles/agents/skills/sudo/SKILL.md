---
name: sudo
description: Use pkexec instead of sudo for privilege escalation on this system. Apply this whenever a command requires elevated privileges.
---

## Rule

This system does not use `sudo`. Always use `pkexec` for privilege escalation instead.

## Usage

Replace any `sudo <command>` invocation with `pkexec <command>`.

**Correct:**
```bash
pkexec systemctl restart nginx
pkexec nixos-rebuild switch
```

**Incorrect:**
```bash
sudo systemctl restart nginx
sudo nixos-rebuild switch
```

## Notes

- `pkexec` is the PolicyKit executor and handles authentication via the desktop session agent.
- It behaves similarly to `sudo` for single-command invocations but does not support all `sudo` flags (e.g. no `-u <user>` shorthand — use `pkexec --user <user> <command>` instead).
- Never suggest or use `sudo` on this system.
