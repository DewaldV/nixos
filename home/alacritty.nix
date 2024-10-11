{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Hack";
        size = 12;
      };
      window.opacity = 0.975;
    };
  };
}
