name:
{ nixpkgs, home-manager, hardware, system, user }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    ../hardware/${name}.nix
    #    ../users/${user}/nixos.nix
    hardware
    ../configuration.nix
  ];
}
