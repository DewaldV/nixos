{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.sway.config = {
    input = lib.mkForce {
      "*" = {
        xkb_layout = "us";
      };
    };

    output = {
      "DP-1" = {
        mode = "3440x1440@165Hz";
        adaptive_sync = "off";
        render_bit_depth = "10";
      };
    };
  };

  programs.waybar.settings = {
    mainBar = {
      temperature = {
        hwmon-path = lib.mkForce "/sys/class/hwmon/hwmon3/temp1_input";
      };
    };
  };

  services.swayidle.enable = lib.mkForce false;
}
