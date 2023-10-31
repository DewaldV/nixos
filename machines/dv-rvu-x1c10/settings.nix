{
  sway = {
    input = {
      "*" = {
        xkb_layout = "gb";
        xkb_options = "ctrl:nocaps";
      };
    };
    battery = { bat = "BAT0"; };
    temperature = { hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input"; };
  };
}
