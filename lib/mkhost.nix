name:
{ nixpkgs, home-manager, extraModules, system, user, overlays }:

let
  homeUserConfig = { config, pkgs, ... }: {
    imports = [ ../users/dewaldv ../machines/${name}/home ];
  };
in nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    { nixpkgs.overlays = overlays; }

    ../machines/${name}
    ../users/${user}/user.nix
    ../common

    home-manager.nixosModule
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = homeUserConfig;
    }
  ] ++ extraModules;
}
