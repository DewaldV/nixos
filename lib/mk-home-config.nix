name:
{
  lib,
  nixos-private,
  pkgs-unstable,
  system,
}:

let
  modules = [
    ../profiles/activation-report/home.nix
    nixos-private.homeManagerModule
    ../machines/${name}/home
  ];
  extraSpecialArgs = {
    inherit nixos-private pkgs-unstable;
    isDarwin = lib.hasSuffix "-darwin" system;
  };
in
{
  inherit modules extraSpecialArgs;

  forUser = username: {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${username}.imports = modules;
    inherit extraSpecialArgs;
  };
}
