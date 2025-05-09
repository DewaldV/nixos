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
}
