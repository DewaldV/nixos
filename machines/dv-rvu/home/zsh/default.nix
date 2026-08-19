{ config, pkgs, ... }:

{
  home.file.".zsh-custom/rust.zsh".source = ./zsh-custom/rust.zsh;
  home.file.".zsh-custom/rvu.zsh".source = ./zsh-custom/rvu.zsh;
}
