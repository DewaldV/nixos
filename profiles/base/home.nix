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

  # Show diff before activation
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    if [[ -e $HOME/.local/state/nix/profiles/home-manager ]]; then
      echo "--- diff to previous home-manager generation"
      ${pkgs.nvd}/bin/nvd diff $HOME/.local/state/nix/profiles/home-manager $newGenPath
      echo "---"
    fi
  '';

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
    nvd
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
