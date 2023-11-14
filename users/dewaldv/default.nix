machineSettings:
{ config, lib, pkgs, ... }:

let
  homeManager = import ./home-manager.nix;
  swayConfig = homeManager machineSettings;
in {
  imports = [ ./ssh.nix swayConfig ];

  home.stateVersion = "22.11";
}
