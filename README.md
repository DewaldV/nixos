# nixos
NixOS Configurations for my personal and work machines.

This repo is for my own machines so it's not really set up to just clone and go but if you feel like taking inspiration feel free to dive in!

## Bootstrapping

The typical workflow is to clone this to a machine I'm setting up and bootstrap it with:

``` shellsession
sudo nixos-rebuild switch --flake '.#<machine_name>'
```
## Usage

Once a machine has been bootstrapped and rebooted any future changes are done with the following make targets.

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

## Setup

The goal of my setup is to be fairly minimal and to mostly get out of the way so I can focus on my work. I prefer driving with the keyboard as much as possible, using VIM keybinds for editing and the CLI for most tasks and the software below reflects that.

### [Sway](https://swaywm.org/)
An excellent tiling window manager and Wayland compositor.
Sway is lightweight, can be keyboard-driven and brilliantly customisable. 
Wayland provides me with a better monitor management and scaling experience on my portable devices compared to X11.

### [Doom Emacs](https://github.com/doomemacs/doomemacs)
VIM binds with the power of Emacs. The pure-gtk build means its now Wayland native as well and handles scaling changed perfectly.

### [Alacritty](https://github.com/alacritty/alacritty), [Tmux](https://github.com/tmux/tmux/wiki) and [zsh](https://www.zsh.org/)
I manage terminal windows in Tmux rather than Sway more out of habit than anything else.
[Oh My Zsh](https://ohmyz.sh/) with a few plugins (`git`, `aws` and `emacs` and others) and my own aliases and functions from [dewaldv/dotfiles](https://github.com/dewaldv/dotfiles)

![image](https://github.com/DewaldV/nixos/assets/1655931/0b5d9c7d-40e5-4ad1-89b6-39b39b615a43)

