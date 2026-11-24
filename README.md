# NixOS

NixOS configurations for my personal and work machines.

This repo is for my own machines so it's not really set up to just clone and go but if you feel like taking inspiration feel free to dive in!

If you're interested in this style of machine management I can recommend the following resources:
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/) - An excellent tutorial and write up for using Flakes, highly recommended!
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Tutorials on Nix and Nixpkgs in incremental steps. Great for learning more about Nix.
- [Home Manager Manual](https://nix-community.github.io/home-manager/) - Core reference for all things Home Manager.
- [NixOS Manual](https://nixos.org/manual/nixos/stable/) - Core reference for all things NixOS.
- [NixOS Wiki](https://nixos.wiki/) - Unofficial user wiki for NixOS, some info is dated but still a good source.

## Bootstrapping

The typical workflow is to clone this to a machine I'm setting up and bootstrap it with:

``` shellsession
sudo nixos-rebuild switch --flake '.#<machine_name>'
```
## Usage

Once a machine has been bootstrapped and rebooted any future changes are done with the following make targets.

Evaluate all configurations:
``` shellsession
make check
```

This evaluates derivation paths for every NixOS and Darwin system, their Home
Manager generations, standalone Home Manager configurations, nested MicroVM
systems and runners, and the installer. It stops on the first evaluation error.
The check uses the pinned flake inputs and requires access to the private input.
Evaluation may fetch inputs or build evaluation-time dependencies; full system
builds use the targets below.

Build the config but don't activate or reboot, just link it into the local dir as `result`.
``` shellsession
make result
```

Build and activate the new config and make it default.
``` shellsession
make switch
```

Build the config and make it the default on next boot.
``` shellsession
make boot
```

Clean out all but the last 5 generations.

``` shellsession
make gc-gen
```

## Profile composition

Profiles under `profiles/` use the following conventions:

- **Paired system/home profiles** include their `home.nix` through
  `home-manager.sharedModules` in `default.nix`. Import the system profile once;
  machine home configurations only need additional selections and overrides.
  Workstation, Sway, gaming, and desktop-app profiles follow this pattern.
- **Home-only profiles**, such as shell, development, editors, and work, are
  imported directly from machine home configurations.
- **Optional client features** are selected by the role that needs them rather
  than automatically enabled alongside a system service. The Tailscale system
  profile configures the daemon; `profiles/workstation/linux.nix` imports its
  home module for the tray. Server roles can use the daemon without the tray,
  and the Linux-specific import keeps it out of Darwin configurations.
- **Standalone Home Manager and cross-platform configurations** can import
  `home.nix` directly when the corresponding system profile is not applicable.
  This also supports client-only use, such as importing `immich/home.nix` for
  the CLI without enabling the Immich server. The full Immich profile includes
  the CLI, and the virtualization profile pairs virt-manager with its home
  connection settings.

`home-manager.sharedModules` applies to every configured Home Manager user on
the host. Use per-user home imports when a feature should only apply to a
particular user. Avoid importing a home module again when a system profile
already includes it.

### Defaults and overrides

Use `lib.mkDefault` on individual shared preferences that machines or roles
customize, such as keyboard layouts and hardware selectors. Set those leaves
normally in machine modules so other shared settings can still merge. Reserve
`lib.mkForce` for deliberate policy overrides or whole-list replacement.

The development profile keeps common Git and SSH behavior separate from
`personal-identity.nix`, which supplies the default identity. The work profile
selects its identity through `identity.nix` using ordinary option definitions.

## Setup

The goal of my setup is to be fairly minimal and to mostly get out of the way so I can focus on my work. I prefer driving with the keyboard as much as possible, using VIM keybinds for editing and the CLI for most tasks and the software below reflects that.

### [Sway](https://swaywm.org/)
An excellent tiling window manager and Wayland compositor.
Sway is lightweight, keyboard-driven and easily customisable.
Wayland provides better monitor management and scaling on portable devices compared to X11.

### [Doom Emacs](https://github.com/doomemacs/doomemacs)
VIM binds with the power of Emacs, now with Wayland support.

### [Foot](https://codeberg.org/dnkl/foot), [Tmux](https://github.com/tmux/tmux/wiki) and [Zsh](https://www.zsh.org/)
I manage terminal windows in Tmux rather than Sway more out of habit than anything else.
[Oh My Zsh](https://ohmyz.sh/) with a few plugins (`git`, `aws` and `emacs` and others) and my own aliases and functions from [home/zsh](home/zsh).

![image](https://github.com/DewaldV/nixos/assets/1655931/0b5d9c7d-40e5-4ad1-89b6-39b39b615a43)
