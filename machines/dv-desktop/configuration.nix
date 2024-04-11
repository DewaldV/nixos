{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";

  console.keyMap = "us";

  services.xserver.layout = "us";
  services.blueman.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    protontricks
    system76-keyboard-configurator
    vulkan-tools
    winetricks
    wineWowPackages.stable
  ];
}
