{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Fira Code:size=8";
        dpi-aware = "yes";
      };
    };
  };
}
