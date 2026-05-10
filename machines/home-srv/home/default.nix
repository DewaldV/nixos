{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../../../profiles/shell/home.nix
  ];

  home.stateVersion = "25.11";
}
