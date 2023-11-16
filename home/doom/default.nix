{ config, pkgs, ... }:

{
  home.file.".doom.d/config.el".source = ./doom.d/config.el;
  home.file.".doom.d/init.el".source = ./doom.d/init.el;
  home.file.".doom.d/packages.el".source = ./doom.d/packages.el;
}
