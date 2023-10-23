{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.consoleMode = "1";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "dv-fw";

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  services.xserver.layout = "us";

  services.blueman.enable = true;
  services.fprintd.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = { enable = true; };

  programs.light.enable = true;

  environment.systemPackages = with pkgs; [ ];
}
