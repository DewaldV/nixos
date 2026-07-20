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
    ../proton-pass/home.nix
  ]
  ++ lib.optionals (!isDarwin) [ ./linux.nix ];

  # Note: home.stateVersion should be set in machine configs

  # User-level base utilities common to all platforms
  home.packages = with pkgs; [
    hyperfine
    ipcalc

    # Text processing
    ispell
    pandoc

    # System utilities
    fastfetch

    # Additional utilities
    editorconfig-core-c
  ];
}
