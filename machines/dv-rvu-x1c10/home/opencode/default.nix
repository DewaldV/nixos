{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.opencode
  ];

  home.file.".config/opencode/config.json".source = ./config.json;
}
