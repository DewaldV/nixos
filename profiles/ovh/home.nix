{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.ovhcloud-cli
  ];
}
