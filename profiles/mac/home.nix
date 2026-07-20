{ pkgs, ... }:

{
  imports = [ ./ghostty.nix ];

  home.packages = with pkgs; [
    colima
  ];
}
