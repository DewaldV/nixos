{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./llm.nix
    ./virt.nix
  ];
}
