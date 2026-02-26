{ config, pkgs, ... }:

{
  imports = [
    ../../../profiles/base/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/work/home.nix

    # Machine-specific overrides
    ./doom
    ./git.nix
    ./opencode # Work-specific opencode config
    ./vscode.nix
    ./zsh
  ];

  home.username = "dewaldv";
  home.homeDirectory = "/home/dewaldv";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}
