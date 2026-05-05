{ ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal.config.hyprland = {
    default = [
      "hyprland"
      "gtk"
    ];
    "org.freedesktop.impl.portal.Screencast" = "hyprland";
    "org.freedesktop.impl.portal.Screenshot" = "hyprland";
  };

  home-manager.sharedModules = [ ./home.nix ];
}
