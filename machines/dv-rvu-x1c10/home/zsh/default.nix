{ config, pkgs, ... }:

{
  home.file.".zsh-custom/rvu.zsh".source = ./zsh/rvu.zsh;
}
