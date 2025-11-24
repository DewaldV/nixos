{ config, pkgs, ... }:

{
  imports = [
    ../../../profiles/base/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/work/home.nix

    # Machine-specific overrides
    ./alacritty.nix
    ./doom
    ./foot.nix
    ./git.nix
    ./sway.nix
    ./xdg-desktop.nix
    ./opencode # Work-specific opencode config
    ./zsh
  ];

  home.username = "dewaldv";
  home.homeDirectory = "/home/dewaldv";
  home.stateVersion = "22.11";

  # All packages now in profiles (base, development, work)
  # No machine-specific packages needed
  home.packages = [ ];

  programs.home-manager.enable = true;
}
