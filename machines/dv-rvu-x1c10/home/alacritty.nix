{ config, pkgs, ... }:

{
  programs.alacritty.package = pkgs.emptyDirectory;
}
