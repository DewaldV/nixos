{
  config,
  pkgs,
  lib,
  isDarwin,
  ...
}:

{
  # Base home-manager configuration
  imports = [
    ./1password/home.nix
  ]
  ++ lib.optionals (!isDarwin) [ ./linux.nix ];

  # Note: home.stateVersion should be set in machine configs

  # User-level base utilities common to all platforms
  home.packages = with pkgs; [
    # System monitoring
    btop
    htop
    # s-tui

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
    nixfmt-rfc-style
    nvd
    vim

    # System utilities
    fastfetch
    lsof

    # Additional utilities
    editorconfig-core-c
  ];
}
