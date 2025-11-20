{ config, pkgs, ... }:

{
  # User-level base utilities
  # These are common tools that every user needs regardless of machine
  home.packages = with pkgs; [
    # System monitoring
    btop
    htop
    powertop
    s-tui

    # Network utilities
    curl
    dig
    ipcalc
    wget

    # File utilities
    file
    tree
    unzip
    stow

    # Text processing
    ispell
    jq

    # Development basics
    git
    nixfmt-rfc-style
    vim

    # System utilities
    distrobox
    fastfetch
    glxinfo
    lsof

    # Wayland/Sway utilities
    grim
    kanshi
    sway-contrib.grimshot
    wl-clipboard

    # Audio/Video
    pavucontrol
    pulseaudio

    # Security/VPN
    proton-pass
    protonvpn-cli
    protonvpn-gui
    yubioath-flutter

    # Communication
    signal-desktop

    # Cloud sync
    insync
  ];
}
