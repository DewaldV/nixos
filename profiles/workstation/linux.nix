{ pkgs, ... }:

{
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
  };

  home.packages = with pkgs; [
    # Power management
    powertop

    # Container tools
    distrobox

    # OpenGL utilities
    mesa-demos

    # Wayland/Sway utilities
    grim
    kanshi
    slurp
    sway-contrib.grimshot
    wl-clipboard

    # Audio
    helvum
    pwvucontrol
    pulseaudio
  ];
}
