{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./immich.nix
    ./llm.nix
    ./virt.nix
  ];
}
