name:
{ nixpkgs, home-manager, nixos-hardware, system, user }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    ../hardware/${name}.nix
    #    ../users/${user}/nixos.nix

    nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
    ../configuration.nix
  ];
}
