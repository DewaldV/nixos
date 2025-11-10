{ config, pkgs, ... }:

{
  imports = [
    ../../profiles/gaming
    ./configuration.nix
    ./hardware.nix
    ./immich.nix
    ./llm.nix
    ./virt.nix
  ];
}
