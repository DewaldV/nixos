{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./user.nix
    ./xdg-mime-types.nix
    ./network.nix
  ];
}
