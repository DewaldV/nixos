{ pkgs, lib, isDarwin, ... }:

{
  # Terminal emulators, shell, and CLI utilities
  imports = [
    ./fzf.nix
    ./tmux.nix
    ./zsh
  ] ++ lib.optionals (!isDarwin) [ ./linux.nix ]
    ++ lib.optionals isDarwin [ ./mac.nix ];

  # Shell utility packages
  home.packages = with pkgs; [
    bat
    eza
    xh
  ];
}
