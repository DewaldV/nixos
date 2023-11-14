machineSettings:
{ config, lib, pkgs, ... }:

let
  homeManager = import ./home-manager.nix;
  swayConfig = homeManager machineSettings;
in {
  imports = [ ./alacritty.nix ./ssh.nix swayConfig ];

  home.stateVersion = "22.11";
}
