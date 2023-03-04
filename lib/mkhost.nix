name:
{ nixpkgs, home-manager, hardware, system, user, overlays }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }

    ../hardware/${name}.nix
    #    ../users/${user}/nixos.nix
    hardware
    ../configuration.nix
  ];
}
