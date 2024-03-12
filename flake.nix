{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixpkgs-rvu = {
      url = "github:uswitch/nixpkgs/cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let mkHost = import ./lib/mkhost.nix;
    in {
      nixosConfigurations.dv-rvu-x1c10 = mkHost "dv-rvu-x1c10" rec {
        inherit nixpkgs nixpkgs-unstable home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          inputs.nixpkgs-rvu.nixosModule
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

        overlays = [ ];
      };

      nixosConfigurations.dv-desktop = mkHost "dv-desktop" rec {
        inherit nixpkgs nixpkgs-unstable home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules = [
          inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc-ssd
        ];

        overlays = [ ];
      };

      nixosConfigurations.dv-fw = mkHost "dv-fw" rec {
        inherit nixpkgs nixpkgs-unstable home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules =
          [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];

        overlays = [ ];
      };
    };
}
