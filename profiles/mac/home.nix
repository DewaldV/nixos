{ pkgs, ... }:

{
  imports = [ ./ghostty.nix ];

  home.packages = with pkgs; [
    colima
  ];

  programs.aerospace = {
    enable = true;
    launchd.enable = true;
  };
}
