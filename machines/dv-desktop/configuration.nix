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

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    piper
    protontricks
    system76-keyboard-configurator
    vulkan-tools
    wineWowPackages.stable
    winetricks
  ];
}
