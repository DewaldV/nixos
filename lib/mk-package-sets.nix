{
  nixpkgs,
  nixpkgs-unstable,
  system,
}:

let
  mkPackages =
    input:
    import input {
      inherit system;
      config.allowUnfree = true;
    };
in
{
  pkgs = mkPackages nixpkgs;
  pkgs-unstable = mkPackages nixpkgs-unstable;
}
