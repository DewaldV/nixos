{
  sway = {
    input = {
      "*" = {
        xkb_layout = "us";
        # xkb_options = "ctrl:nocaps";
      };
    };

    temperature = { hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input"; };
  };
}
