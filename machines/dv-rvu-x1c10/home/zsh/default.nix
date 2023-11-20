{ config, pkgs, ... }:

{
  home.file.".zsh-custom/rvu.zsh".source = ./zsh-custom/rvu.zsh;
}
