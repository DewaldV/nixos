{ config, pkgs, ... }:

{
  # Immich CLI tool for photo management
  home.packages = with pkgs; [
    immich-go
  ];
}
