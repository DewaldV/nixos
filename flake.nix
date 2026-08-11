{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    zeroclaw = {
      url = "github:zeroclaw-labs/zeroclaw/v0.8.3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-private = {
      url = "git+ssh://git@github.com/dewaldv/nixos-private";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      disko,
      home-manager,
      microvm,
      nix-darwin,
      nixos-hardware,
      nixos-private,
      nixpkgs,
      nixpkgs-unstable,
      zeroclaw,
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
          disko
          home-manager
          nixos-hardware
          nixos-private
          nixpkgs
          nixpkgs-unstable
          ;
        system = "x86_64-linux";
      };

      darwinConfigurations.USW-TQWC4MH4Y7 = mkDarwin "dv-rvu-mac" {
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
          disko
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
          disko
          home-manager
          microvm
          nixos-hardware
          nixos-private
          nixpkgs
          nixpkgs-unstable
          zeroclaw
          ;
        system = "x86_64-linux";
      };

      nixosConfigurations.dl-vm = mkHost "dl-vm" {
        inherit
          disko
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
