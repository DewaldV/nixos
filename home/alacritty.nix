{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 12;
      window.opacity = 0.975;
    };
  };
}
