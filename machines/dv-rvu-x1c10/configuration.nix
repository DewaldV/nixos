{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "1";

  networking.hostName = "dv-rvu-x1c10";

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "uk";
  };

  services.fprintd.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.xserver.layout = "gb";

  environment.systemPackages = with pkgs; [
    azure-cli
    rvu-u
    rvu-kolide
    # ipu6-drivers
    # ipu6-camera-bins
    # ipu6-camera-hal
    # icamerasrc
    # ivsc-driver
    # ivsc-firmware
  ];
}
