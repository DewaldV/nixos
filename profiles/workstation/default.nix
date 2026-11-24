{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./user.nix
    ../tailscale
  ];

  home-manager.sharedModules = [ ./home.nix ];
}
