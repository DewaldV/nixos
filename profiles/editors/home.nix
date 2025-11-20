{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Editor configurations and packages
  imports = [
    ./doom
    ./editorconfig.nix
    ./neovim.nix
  ];

  home.packages = [
    pkgs-unstable.opencode
    pkgs-unstable.claude-code
  ];
}
