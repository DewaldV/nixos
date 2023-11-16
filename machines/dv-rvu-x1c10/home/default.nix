{ config, pkgs, ... }:
let composeHome = import ../../../lib/composehome.nix;
in { imports = composeHome [ ./git.nix ./sway.nix ./xdg-desktop.nix ./zsh ]; }
