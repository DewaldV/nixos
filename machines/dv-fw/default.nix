{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./user.nix
  ];
}
