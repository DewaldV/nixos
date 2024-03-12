name:
{ nixpkgs, nixpkgs-unstable, home-manager, extraModules, system, user, overlays
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
  };

  modules = [
    { nixpkgs.overlays = overlays; }

    ../machines/${name}
    ../users/${user}/user.nix
    ../common

    home-manager.nixosModule
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = ../machines/${name}/home;
    }
  ] ++ extraModules;
}
