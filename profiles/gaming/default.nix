{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Gaming programs
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.gamescope.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Gaming packages (common to both machines)
  environment.systemPackages = with pkgs; [
    heroic
    lutris
    protontricks
    scummvm
    vulkan-tools
    winetricks
  ];

  # Home-manager configuration for gaming
  home-manager.sharedModules = [ ./home.nix ];
}
