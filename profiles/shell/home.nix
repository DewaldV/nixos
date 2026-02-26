{ config, pkgs, ... }:

{
  # Terminal emulators, shell, and CLI utilities
  imports = [
    ./foot.nix
    ./fzf.nix
    ./tmux.nix
    ./zsh
  ];

  # Shell utility packages
  home.packages = with pkgs; [
    bat
    eza
    xh
  ];
}
