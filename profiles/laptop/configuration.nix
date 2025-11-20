{ config, pkgs, ... }:

{
  # Laptop-specific services and configuration
  services.blueman.enable = true;
  services.fprintd.enable = true;

  # Power management
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  # Backlight control
  programs.light.enable = true;
}
