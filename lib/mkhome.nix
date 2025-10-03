name:
{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  system,
}:

let
  pkgs = nixpkgs.legacyPackages.${system};
  pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
in
home-manager.lib.homeManagerConfiguration {
  pkgs = pkgs;

  extraSpecialArgs = {
    pkgs-unstable = pkgs-unstable;
  };

  modules = [
    ../machines/${name}/home
  ];
}
