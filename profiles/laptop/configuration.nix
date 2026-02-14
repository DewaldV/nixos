{ config, pkgs, ... }:

{
  # Laptop-specific services and configuration
  services.blueman.enable = true;
  services.fprintd.enable = true;

  # Power management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      RESTORE_DEVICE_STATE_ON_STARTUP = 0;
    };
  };

  # Backlight control
  programs.light.enable = true;

  # Trigger suspend then hibernate
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.lidSwitchExternalPower = "suspend-then-hibernate";
}
