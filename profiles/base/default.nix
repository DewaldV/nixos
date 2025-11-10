{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./xdg-mime-types.nix
  ];
}
