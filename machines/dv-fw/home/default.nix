{ config, pkgs, ... }:
let
  composeHome = import ../../../lib/composehome.nix;
in
{
  imports = composeHome [
    ../../../profiles/sway/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/desktop-apps/home.nix
    ../../../profiles/editors/home.nix
    ./sway.nix
  ];

  # Machine-specific packages
  home.packages = with pkgs; [
    godot_4 # Game engine for development
  ];
}
