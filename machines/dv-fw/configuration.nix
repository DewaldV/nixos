{ config, pkgs, ... }:

{
  boot = { loader.systemd-boot.consoleMode = "1"; };

  networking.hostName = "dv-fw";

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  services.xserver.layout = "us";

  services.fwupd.extraRemotes = [ "lvfs-testing" ];
  services.fwupd.uefiCapsuleSettings = { DisableCapsuleUpdateOnDisk = true; };

  services.blueman.enable = true;
  services.fprintd.enable = true;

  services.power-profiles-daemon.enable = true;

  programs.light.enable = true;

  environment.systemPackages = with pkgs; [ ];
}
