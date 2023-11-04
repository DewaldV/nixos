{
  sway = {
    input = {
      "*" = {
        xkb_layout = "us";
        # xkb_options = "ctrl:nocaps";
      };
    };

    output.edp.scale = "1.25";
    battery.bat = "BAT1";

    temperature = { hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input"; };
  };
}
