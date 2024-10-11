{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
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
