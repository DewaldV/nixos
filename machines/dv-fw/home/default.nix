{ config, pkgs, ... }:

{
  imports = [
    ../../../profiles/base/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/sway/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/desktop-apps/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/sync/home.nix
    ../../../profiles/ovh/home.nix
    ./sway.nix
  ];

  home.stateVersion = "22.11";

  # Machine-specific packages
  home.packages = with pkgs; [
    godot_4 # Game engine for development
  ];
}
