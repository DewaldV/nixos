{ config, pkgs, ... }:

{
  # Note: Laptop-specific services moved to profiles/laptop
  boot.loader.systemd-boot.consoleMode = "1";

  networking.firewall.enable = true;

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "ctrl:nocaps";
  };

  services.fwupd = {
    extraRemotes = [ "lvfs-testing" ];
    uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
  };

  profiles.dns.quad9 = {
    enable = true;
    dnsOverTls = true;
  };
}
