{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-rvu.url = "github:uswitch/nixpkgs?ref=kolide";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    ipu6-nix.url = "github:dewaldv/ipu6-nix";

    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let mkHost = import ./lib/mkhost.nix;
    in {
      nixosConfigurations.dv-rvu-x1c10 = mkHost "dv-rvu-x1c10" rec {
        inherit nixpkgs home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          inputs.nixpkgs-rvu.nixosModule
          inputs.home-manager.nixosModule
        ];

        overlays =
          [ inputs.ipu6-nix.overlay.${system} inputs.emacs.overlays.emacs ];
      };

      nixosConfigurations.dv-rvu-desktop = mkHost "dv-rvu-desktop" rec {
        inherit nixpkgs home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules = [ inputs.nixpkgs-dewaldv.nixosModules.rvu-kolide ];

        overlays = [ inputs.nixpkgs-dewaldv.overlay.${system} ];
      };

      nixosConfigurations.dv-desktop = mkHost "dv-desktop" rec {
        inherit nixpkgs home-manager;
        system = "x86_64-linux";
        user = "dewaldv";

        extraModules = [ ];

        overlays = [ ];
      };
    };
}
