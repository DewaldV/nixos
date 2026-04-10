{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./user.nix
    ../tailscale
    ./1password
  ];
}
