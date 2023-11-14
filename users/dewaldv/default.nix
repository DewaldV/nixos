machineSettings:
{ config, lib, pkgs, ... }:

let
  homeManager = import ./home-manager.nix;
  swayConfig = homeManager machineSettings;
in {
  imports =
    [ ./alacritty.nix ./editorconfig.nix ./git.nix ./ssh.nix swayConfig ];

  home.stateVersion = "22.11";
}
