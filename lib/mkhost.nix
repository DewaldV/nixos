name:
{
  disko,
  home-manager,
  microvm ? null,
  nixos-hardware,
  nixos-private,
  nixpkgs,
  nixpkgs-unstable,
  recon ? null,
  zeroclaw ? null,
  system,
  username,
}:

let
  inherit (import ./mk-package-sets.nix { inherit nixpkgs nixpkgs-unstable system; }) pkgs-unstable;
  homeConfig = import ./mk-home-config.nix name {
    lib = nixpkgs.lib;
    inherit nixos-private pkgs-unstable system;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit
      disko
      microvm
      nixos-hardware
      nixos-private
      pkgs-unstable
      recon
      zeroclaw
      ;
  };

  modules = [
    nixos-private.nixosModule
    ../profiles/activation-report
    ../profiles/core-tools
    ../machines/${name}

    home-manager.nixosModules.home-manager
    {
      networking.hostName = nixpkgs.lib.mkDefault name;

      home-manager = homeConfig.forUser username;
    }
  ];
}
