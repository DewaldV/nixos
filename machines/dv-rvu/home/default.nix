{ config, pkgs, ... }:

{
  imports = [
    ../../../profiles/workstation/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/work/home.nix
    ../../../profiles/desktop-apps/foot.nix

    # Machine-specific overrides
    ./doom
    ./git.nix
    ./opencode # Work-specific opencode config
    ./zsh
  ];

  # New config
  targets.genericLinux.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home.packages = with pkgs; [
    bat
    btop
    curl
    dig
    eza
    fd
    file
    fzf
    gnumake
    htop
    jq
    lsof
    ripgrep
    tmux
    tree
    unzip
    vim
    wget
    xh

    # Nix tooling
    nixfmt
    nvd
  ];

  home.username = "dewaldv";
  home.homeDirectory = "/home/dewaldv";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}
