{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./user.nix
    ./tailscale.nix
    ./1password
  ];
}
