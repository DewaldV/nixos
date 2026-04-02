{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    pkgs-unstable.proton-pass-cli
  ];

  programs.aerospace = {
    enable = true;
    launchd.enable = true;
  };
}
