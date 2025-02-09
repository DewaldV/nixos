{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  boot.loader.systemd-boot.consoleMode = "1";

  networking.hostName = "dv-rvu-x1c10";

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "uk";
  };

  services.xserver.xkb.layout = "gb";

  services.blueman.enable = true;
  services.fprintd.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  programs.light.enable = true;

  # RVU specific services
  services.rvu-kolide.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}
