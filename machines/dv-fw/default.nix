{ config, pkgs, ... }:
{
  imports = [
    ../../profiles/gaming
    ../../profiles/laptop
    # Note: development and desktop-apps profiles are home-manager only (no system config)
    ./configuration.nix
    ./hardware.nix
  ];
}
