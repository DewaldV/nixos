{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "1";

  networking.hostName = "dv-fw";

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

  services.blueman.enable = true;
  services.fprintd.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  programs.light.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
    protontricks
    vulkan-tools
    winetricks
  ];
}
