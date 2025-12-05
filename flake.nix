{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
    }:
    let
      mkHome = import ./lib/mkhome.nix;
      mkHost = import ./lib/mkhost.nix;
    in
    {
      homeConfigurations.dewaldv = mkHome "dv-rvu-x1c10" rec {
        inherit nixpkgs nixpkgs-unstable home-manager;
        system = "x86_64-linux";
      };

      nixosConfigurations.dv-desktop = mkHost "dv-desktop" {
        inherit
          nixpkgs
          nixpkgs-unstable
          nixos-hardware
          home-manager
          ;
        system = "x86_64-linux";
      };

      nixosConfigurations.dv-fw = mkHost "dv-fw" {
        inherit
          nixpkgs
          nixpkgs-unstable
          nixos-hardware
          home-manager
          ;
        system = "x86_64-linux";
      };
    };
}
