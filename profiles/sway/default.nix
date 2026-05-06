{ config, ... }:

{
  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export WLR_RENDERER=vulkan;
    '';
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.Screencast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
    };
  };

  security.pam.services.swaylock = { };

  home-manager.sharedModules = [ ./home.nix ];
}
