{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.opencode
    pkgs-unstable.claude-code
  ];
}
