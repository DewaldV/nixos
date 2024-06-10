{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.sway = {
    config = {
      input = lib.mkForce {
        "*" = {
          xkb_layout = "gb";
          xkb_options = "ctrl:nocaps";
        };
      };

      output = {
        "eDP-1" = {
          pos = lib.mkForce "760 1440";
          scale = lib.mkForce "1.50";
        };

        "DP-3" = {
          mode = "3440x1440@100Hz";
          pos = "0 0";
          adaptive_sync = "off";
        };
      };
    };
  };

  programs.waybar = {
    settings = {
      mainBar = {
        battery = {
          bat = lib.mkForce "BAT0";
        };
        temperature = {
          hwmon-path = lib.mkForce "/sys/class/hwmon/hwmon5/temp1_input";
        };
      };
    };
  };
}
