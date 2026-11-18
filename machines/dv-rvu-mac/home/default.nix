{ pkgs, ... }:

{
  imports = [
    ../../../profiles/workstation/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/work/home.nix
    ../../../profiles/mac/home.nix
    ../../../profiles/agents/opencode
  ];

  home.packages = with pkgs; [
    docker
    src-cli
  ];

  home.username = "dewald.viljoen";
  home.homeDirectory = "/Users/dewald.viljoen";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
