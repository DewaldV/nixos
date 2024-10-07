{ config, pkgs, ... }:
let
  composeHome = import ../../../lib/composehome.nix;
in
{
  imports = composeHome [
    ./alacritty.nix
    ./foot.nix
    ./git.nix
    ./xdg-desktop.nix
    ./zsh
  ];

  home.username = "dewaldv";
  home.homeDirectory = "/home/dewaldv";
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    curl
    dig
    fastfetch
    fd
    file
    gh
    helmfile
    htop
    ipcalc
    jq
    lsof
    nixfmt-rfc-style
    ripgrep
  ];
  programs.home-manager.enable = true;
}
