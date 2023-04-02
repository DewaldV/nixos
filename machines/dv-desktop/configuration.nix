{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";

  console = { keyMap = "us"; };

  services.xserver.layout = "us";

  environment.systemPackages = with pkgs; [ ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
