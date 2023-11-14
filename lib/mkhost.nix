name:
{ nixpkgs, home-manager, extraModules, system, user, overlays }:

let
  machineSettings = import ../machines/${name}/settings.nix;
  homeUserConfig = import ../users/${user};
in nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    { nixpkgs.overlays = overlays; }

    ../machines/${name}/hardware.nix
    ../machines/${name}/configuration.nix
    ../users/${user}/user.nix
    ../common/configuration.nix
    ../common/xdg-mime-types.nix

    home-manager.nixosModule
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = homeUserConfig machineSettings;
    }
  ] ++ extraModules;
}
