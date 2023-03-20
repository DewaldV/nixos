{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url =
      "github:nixos/nixos-hardware?rev=77de4cd09db4dbee9551ed2853cfcf113d7dc5ce";

    ipu6-nix.url = "github:dewaldv/ipu6-nix";
    nixpkgs-dewaldv.url = "github:dewaldv/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let

      mkHost = import ./lib/mkhost.nix;
    in {
      nixosConfigurations.dv-rvu-x1c10 = mkHost "dv-rvu-x1c10" rec {
        inherit nixpkgs home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          inputs.nixpkgs-dewaldv.nixosModules.rvu-kolide
        ];

        overlays = [
          inputs.ipu6-nix.overlay.${system}
          inputs.nixpkgs-dewaldv.overlay.${system}
          (final: prev: {
            steampipe =
              inputs.nixpkgs-unstable.legacyPackages.${prev.system}.steampipe;
          })
        ];
      };
    };
}
