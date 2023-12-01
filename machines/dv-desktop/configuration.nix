{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.consoleMode = "0";
    kernelPackages = pkgs.linuxPackages_6_6;
  };

  networking.hostName = "dv-desktop";

  console = { keyMap = "us"; };

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
    system76-keyboard-configurator
    vulkan-tools
    winetricks
    wineWowPackages.stable
  ];
}
