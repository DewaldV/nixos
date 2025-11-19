{ config, pkgs, ... }:

{
  home.file.".doom.d/work/config.el".source = ./doom.d/work/config.el;
}
