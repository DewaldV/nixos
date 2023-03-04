{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url =
      "github:nixos/nixos-hardware?rev=77de4cd09db4dbee9551ed2853cfcf113d7dc5ce";

    # ipu6-nix.url = "path:../ipu6-nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }: {
    nixosConfigurations.dv-rvu-x1c10 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./rvu-lenovo-x1-carbon-gen-10/configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
      ];
    };
  };
}
