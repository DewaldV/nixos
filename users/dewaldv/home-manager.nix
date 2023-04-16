{ config, lib, pkgs, ... }:

{
  home.stateVersion = "22.11";

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
      ];
    };
  };
}
