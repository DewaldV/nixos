{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot-direct";
        font = "Hack:size=12";
        dpi-aware = "no";
      };

      colors = {
        alpha = 0.925;
        foreground = "ffffff";
        background = "000000";
      };
    };
  };
}
