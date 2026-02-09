{ config, pkgs, ... }:

{
  # Note: Laptop-specific services moved to profiles/laptop
  boot.loader.systemd-boot.consoleMode = "1";

  networking.hostName = "dv-fw";

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      41641 # Tailscale
    ];
  };

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  services.xserver.xkb.layout = "us";

  services.fwupd = {
    extraRemotes = [ "lvfs-testing" ];
    uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
  };
}
