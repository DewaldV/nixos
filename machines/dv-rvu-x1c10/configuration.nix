{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.consoleMode = "1";

  networking.hostName = "dv-rvu-x1c10";

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "uk";
  };

  services.xserver.layout = "gb";

  services.blueman.enable = true;
  services.fprintd.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = { CPU_SCALING_GOVERNOR_ON_AC = "performance"; };
  };

  programs.light.enable = true;

  environment.systemPackages = with pkgs; [ azure-cli jdk17 maven u ];

  # RVU specific services
  services.rvu-kolide.enable = true;
  services.awsvpnclient = {
    enable = true;
    configFile = "/home/dewaldv/.config/rvu/aws-vpn-client/cvpn.ovpn";
  };

}
