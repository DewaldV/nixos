name:
{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  extraModules,
  system,
  user,
  overlays,
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
    inherit pkgs-unstable;
  };

  modules = [
    { nixpkgs.overlays = overlays; }

    ../machines/${name}
    ../users/${user}/user.nix
    ../profiles/base

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.${user} = ../machines/${name}/home;
      home-manager.extraSpecialArgs = {
        inherit pkgs-unstable;
      };
    }
  ]
  ++ extraModules;
}
