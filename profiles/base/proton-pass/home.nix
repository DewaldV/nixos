{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.proton-pass
    pkgs-unstable.proton-pass-cli
  ];
}
