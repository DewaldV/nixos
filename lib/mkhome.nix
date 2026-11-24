name:
{
  home-manager,
  nixos-private,
  nixpkgs,
  nixpkgs-unstable,
  system,
}:

let
  inherit (import ./mk-package-sets.nix { inherit nixpkgs nixpkgs-unstable system; })
    pkgs
    pkgs-unstable
    ;
  homeConfig = import ./mk-home-config.nix name {
    lib = nixpkgs.lib;
    inherit nixos-private pkgs-unstable system;
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  inherit (homeConfig) modules extraSpecialArgs;
}
