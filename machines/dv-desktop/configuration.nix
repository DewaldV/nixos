{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";

  console.keyMap = "us";

  services.xserver.xkb.layout = "us";
  services.blueman.enable = true;
  services.ratbagd.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.gamescope.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    piper
    protontricks
    scummvm
    system76-keyboard-configurator
    vulkan-tools
    wineWowPackages.stable
    winetricks
  ];

  services.tailscale.enable = true;
}
