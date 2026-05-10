{ ... }:

{
  imports = [
    ./xdg-mime-types.nix
  ];

  home-manager.sharedModules = [ ./home.nix ];
}
