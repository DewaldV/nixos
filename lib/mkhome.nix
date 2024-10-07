name:
{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  system,
}:

home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  modules = [
    ../machines/${name}/home
  ];
}