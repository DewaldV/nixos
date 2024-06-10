{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./lanzaboote.nix
    ./virt.nix
  ];
}
