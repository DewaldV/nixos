{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./editorconfig.nix
    ./git.nix
    ./ssh.nix
    ./home-manager.nix
  ];

  home.stateVersion = "22.11";
}
