{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-a";
    sensibleOnTop = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.fzf-tmux-url
    ];
  };

  home.packages = with pkgs; [
    fzf
  ];
}
