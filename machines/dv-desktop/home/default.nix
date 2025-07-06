{ config, pkgs, ... }:
let
  composeHome = import ../../../lib/composehome.nix;
in
{

  imports = composeHome [
    ./dconf.nix
    ../../../sway
    ./sway.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    bun
    nodejs_24
  ];
}
