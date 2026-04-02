{ pkgs, ... }:

{
  imports = [
    ./gtk.nix
    ./proton-pass/home.nix
  ];

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
    sway-contrib.grimshot
    wl-clipboard

    # Audio
    helvum
    pavucontrol
    pulseaudio
  ];
}
