{ config, pkgs, ... }:
let
  composeHome = import ../../../lib/composehome.nix;
in
{
  imports = composeHome [
    ../../../sway
    ./alacritty.nix
    ./foot.nix
    ./git.nix
    ./sway.nix
    ./xdg-desktop.nix
    ./zsh
  ];

  home.username = "dewaldv";
  home.homeDirectory = "/home/dewaldv";
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    awscli2
    aws-sam-cli
    azure-cli
    btop
    curl
    dig
    dotnet-sdk
    fastfetch
    file
    gh
    helmfile
    htop
    ipcalc
    jq
    lsof
    nixfmt-rfc-style
    pavucontrol
    signal-desktop
    snyk
    tree
    unzip
    vim
    wget
    yq-go
  ];

  programs.home-manager.enable = true;
}
