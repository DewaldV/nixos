{
  config,
  pkgs,
  ...
}:

{
  # Editor configurations and packages
  imports = [
    ./doom
    ./editorconfig.nix
    ./neovim.nix
  ];
}
