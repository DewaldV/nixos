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

  # Trigger suspend then hibernate
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "2h";
    SuspendState = "mem";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend"; # Only suspend when plugged in, don't hibernate
  };
}
