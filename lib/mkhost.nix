name:
{
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
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit nixos-hardware nixos-private pkgs-unstable;
  };

  modules = [
    nixos-private.nixosModule
    ../machines/${name}
    ../profiles/base

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.dewaldv =
        {
          ...
        }:
        {
          imports = [
            nixos-private.homeManagerModule
            ../machines/${name}/home
          ];
        };
      home-manager.extraSpecialArgs = {
        inherit nixos-private pkgs-unstable;
      };
    }
  ];
}
