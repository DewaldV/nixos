{ config, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./doom
    ./editorconfig.nix
    ./git.nix
    ./gtk.nix
    ./ssh.nix
    ./sway.nix
    ./tmux
    ./zsh
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
  };

  home.stateVersion = "22.11";
}
