name:
{
  disko,
  home-manager,
  nixos-hardware,
  nixos-private,
  nixpkgs,
  nixpkgs-unstable,
  system,
}:

let
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openclaw-2026.5.7"
      ];
    };
  };
  isDarwin = nixpkgs.lib.hasSuffix "-darwin" system;
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit
      disko
      nixos-hardware
      nixos-private
      pkgs-unstable
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

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.dewaldv =
        {
          ...
        }:
        {
          imports = [
            ../profiles/activation-report/home.nix
            nixos-private.homeManagerModule
            ../machines/${name}/home
          ];
        };
      home-manager.extraSpecialArgs = {
        inherit nixos-private pkgs-unstable isDarwin;
      };
    }
  ];
}
