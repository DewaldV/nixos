{ config, pkgs, ... }:
{
  imports = [ ./configuration.nix ];

  home-manager.sharedModules = [ ./home.nix ];
}
