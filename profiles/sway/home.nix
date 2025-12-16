# home-manager module for Sway config
{ config, pkgs, ... }:

{
  imports = [
    ./fuzzel.nix
    ./mako.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    bemoji
    wtype
  ];
}
