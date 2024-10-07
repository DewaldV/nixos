{ config, pkgs, ... }:
let
  composeHome = import ../../../lib/composehome.nix;
in
{
  imports = composeHome [ ../../sway ./sway.nix ];
}
