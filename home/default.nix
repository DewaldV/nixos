{ config, pkgs, ... }:

{
  imports = [
    ./1password
    ./alacritty.nix
    ./direnv.nix
    ./doom
    ./editorconfig.nix
    ./foot.nix
    ./fzf.nix
    ./git.nix
    ./gtk.nix
    ./rust
    ./ssh.nix
    ./tmux.nix
    ./zsh
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
  };

  home.stateVersion = "22.11";
}
