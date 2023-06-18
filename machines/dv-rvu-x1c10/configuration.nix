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

  security.polkit.enable = true;

  # RVU specific services
  services.rvu-kolide.enable = true;
  # services.awsvpnclient = {
  #   enable = true;
  #   configFile = "/home/dewaldv/.config/rvu/aws-vpn-client/cvpn.ovpn";
  # };
  services.blueman.enable = true;

  services.fprintd.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.xserver.layout = "gb";

  programs.light.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    kanshi
    swaylock
    azure-cli
    u
    wofi
    # ipu6-drivers
    # ipu6-camera-bins
    # ipu6-camera-hal
    # icamerasrc
    # ivsc-driver
    # ivsc-firmware
  ];

  virtualisation = {
    docker = { enable = true; };
    podman = { enable = true; };
  };
}
