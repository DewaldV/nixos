{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "1";

  networking.hostName = "dv-rvu-desktop";

  console = { keyMap = "us"; };

  services.xserver.layout = "us";

  services.blueman.enable = true;
  programs.light.enable = true;

  environment.systemPackages = with pkgs; [ azure-cli u ];

  # RVU specific services
  services.rvu-kolide.enable = true;
  services.awsvpnclient = {
    enable = true;
    configFile = "/home/dewaldv/.config/rvu/aws-vpn-client/cvpn.ovpn";
  };
}
