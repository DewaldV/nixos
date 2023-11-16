{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway.config = {
    input = lib.mkForce { "*" = { xkb_layout = "us"; }; };
  };

  programs.waybar.settings = {
    mainBar = {
      temperature = {
        hwmon-path = lib.mkForce "/sys/class/hwmon/hwmon3/temp1_input";
      };
    };
  };
}
