name:
{
  home-manager,
  nixos-private,
  nixpkgs,
  nixpkgs-unstable,
  system,
}:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit nixos-private pkgs-unstable;
  };

  modules = [
    ../machines/${name}/home
  ];
}
