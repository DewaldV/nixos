{ config, pkgs, ... }: {
  imports = [ ../../../users/dewaldv ./git.nix ./sway.nix ./xdg-desktop.nix ];
}
