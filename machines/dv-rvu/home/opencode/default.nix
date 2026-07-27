{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.opencode
    pkgs-unstable.herdr
  ];

  home.file.".config/opencode/config.json".source = ./config.json;
  home.file.".config/opencode/AGENTS.md".source = ./AGENTS.md;
}
