{ config, pkgs, ... }:
let
  composeHome = import ../../../lib/composehome.nix;
in
{
  imports = composeHome [
    ../../../profiles/sway/home.nix
    ./sway.nix
  ];
}
