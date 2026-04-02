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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nix-darwin,
      nixos-hardware,
      nixos-private,
      nixpkgs,
      nixpkgs-unstable,
    }:
    let
      mkHome = import ./lib/mkhome.nix;
      mkHost = import ./lib/mkhost.nix;
      mkDarwin = import ./lib/mkdarwin.nix;
    in
    {
      packages.x86_64-linux.installer =
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-private; };
          modules = [ ./installer ];
        }).config.system.build.isoImage;

      homeConfigurations.dewaldv = mkHome "dv-rvu" rec {
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

      darwinConfigurations.RVU-TQWC4MH4Y7 = mkDarwin "dv-rvu-mac" {
        inherit
          nix-darwin
          home-manager
          nixos-private
          nixpkgs
          nixpkgs-unstable
          ;
        system = "aarch64-darwin";
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

      nixosConfigurations.home-srv = mkHost "home-srv" {
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
