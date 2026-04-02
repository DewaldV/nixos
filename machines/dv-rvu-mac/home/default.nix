{ ... }:

{
  imports = [
    ../../../profiles/base/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/development/home.nix
    # ../../../profiles/editors/home.nix
    ../../../profiles/work/home.nix
    ../../../profiles/mac/home.nix

    # Shared with dv-rvu
    ../../dv-rvu/home/doom
    ../../dv-rvu/home/git.nix
    ../../dv-rvu/home/opencode

    ./zsh
  ];

  home.username = "dewald.viljoen";
  home.homeDirectory = "/Users/dewald.viljoen";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
