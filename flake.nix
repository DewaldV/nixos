{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      mkHome = import ./lib/mkhome.nix;
      mkHost = import ./lib/mkhost.nix;
    in
    {
      homeConfigurations.dewaldv = mkHome "dv-rvu-x1c10" rec {
        inherit nixpkgs nixpkgs-unstable home-manager;
        system = "x86_64-linux";
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

        extraModules = [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];

        overlays = [ ];
      };
    };
}
