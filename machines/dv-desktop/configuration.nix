{ config, pkgs, ... }: {
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";

  console = { keyMap = "us"; };

  services.xserver.layout = "us";
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
