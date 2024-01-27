{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./virt.nix

  ];
}
