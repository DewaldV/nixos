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

  environment.systemPackages = with pkgs; [
    awsvpnclient
    azure-cli
    cilium-cli
    docker-compose
    jdk17
    kind
    mangohud
    maven
    nodejs_18
    sbctl
    snyk
    u
    pkgs-unstable.vscode-fhs
    pkgs-unstable.dotnet-sdk_8
    yq-go
  ];

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
