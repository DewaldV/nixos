{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Base home-manager configuration
  imports = [
    ./1password
    ./gtk.nix
  ];

  # Pointer cursor configuration
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
  };

  # Note: home.stateVersion should be set in machine configs

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

    # Text processing
    ispell
    jq
    pandoc

    # Development basics
    # Note: git moved to development profile
    nixfmt-rfc-style
    vim

    # System utilities
    distrobox
    fastfetch
    lsof
    mesa-demos

    # Wayland/Sway utilities
    grim
    kanshi
    sway-contrib.grimshot
    wl-clipboard

    # Audio/Video
    helvum
    pavucontrol
    pulseaudio

    # Security/VPN
    proton-pass

    # Additional utilities
    editorconfig-core-c
  ];
}
