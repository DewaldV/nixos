{ ... }:

{
  wayland.windowManager.sway.config = {
    input = {
      "*" = {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
        xkb_options = "ctrl:nocaps";
      };
    };

    output."eDP-1".scale = "1.5";
  };

  programs.waybar.settings = {
    mainBar = {
      battery = {
        bat = "BAT1";
      };
      temperature = {
        hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
      };
    };
  };
}
