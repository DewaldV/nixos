name:
{
  nixpkgs,
  nixpkgs-unstable,
  nixos-hardware,
  home-manager,
  system,
  user,
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
    inherit pkgs-unstable nixos-hardware;
  };

  modules = [
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
  ];
}
