name:
{ nixpkgs, home-manager, hardware, system, user, overlays }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }
    ../machines/${name}/hardware.nix
    ../machines/${name}/configuration.nix
    ../users/${user}/user.nix
    ../configuration.nix
    hardware
  ];
}
