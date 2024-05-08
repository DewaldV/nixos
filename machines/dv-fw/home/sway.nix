{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    config = {
      input = lib.mkForce {
        "*" = {
          xkb_layout = "us";
          xkb_options = "ctrl:nocaps";
        };
      };

      output."eDP-1".scale = lib.mkForce "1.0";
    };
  };

  programs.waybar = {
    settings = {
      mainBar = {
        battery = { bat = lib.mkForce "BAT1"; };
        temperature = {
          hwmon-path = lib.mkForce "/sys/class/hwmon/hwmon4/temp1_input";
        };
      };
    };
  };
}
