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

    nixos-private = {
      url = "git+ssh://git@github.com/dewaldv/nixos-private";
      flake = true;
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixos-hardware,
      nixos-private,
      nixpkgs,
      nixpkgs-unstable,
    }:
    let
      mkHome = import ./lib/mkhome.nix;
      mkHost = import ./lib/mkhost.nix;
    in
    {
      homeConfigurations.dewaldv = mkHome "dv-rvu-x1c10" rec {
        inherit
          home-manager
          nixos-private
          nixpkgs
          nixpkgs-unstable
          ;
        system = "x86_64-linux";
      };

      nixosConfigurations.dv-desktop = mkHost "dv-desktop" {
        inherit
          home-manager
          nixos-hardware
          nixos-private
          nixpkgs
          nixpkgs-unstable
          ;
        system = "x86_64-linux";
      };

      nixosConfigurations.dv-fw = mkHost "dv-fw" {
        inherit
          home-manager
          nixos-hardware
          nixos-private
          nixpkgs
          nixpkgs-unstable
          ;
        system = "x86_64-linux";
      };
    };
}
