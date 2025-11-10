{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";

  console.keyMap = "us";

  services.xserver.xkb.layout = "us";
  services.blueman.enable = true;
  services.ratbagd.enable = true;

  services.power-profiles-daemon.enable = true;

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    piper
    system76-keyboard-configurator
  ];

  services.tailscale.enable = true;
}
