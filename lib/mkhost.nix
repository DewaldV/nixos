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
  ] ++ extraModules;
}
