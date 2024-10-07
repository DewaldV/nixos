{ config, pkgs, ... }:

{
  imports = [
    ./1password
    ./alacritty.nix
    ./direnv.nix
    ./doom
    ./editorconfig.nix
    ./foot.nix
    ./git.nix
    ./gtk.nix
    ./rust
    ./ssh.nix
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
