name:
{ nixpkgs, home-manager, extraModules, system, user, overlays }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }

    ../machines/${name}/hardware.nix
    ../machines/${name}/configuration.nix
    ../users/${user}/user.nix
    ../common/configuration.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-manager.nix;
    }
  ] ++ extraModules;
}
