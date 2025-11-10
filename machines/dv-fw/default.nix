{ config, pkgs, ... }:
{
  imports = [
    ../../profiles/gaming
    ./configuration.nix
    ./hardware.nix
    ./user.nix
  ];
}
