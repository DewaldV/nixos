{ config, pkgs, home-manager, ... }:

{
  users.users.dewaldv.packages = with pkgs; [
    godot_4
    haxe
    libX11
    libXext
    libXi
    libXinerama
    libxrandr
    neko
  ];
}
