{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-a";
    sensibleOnTop = true;
    terminal = "tmux-direct";
    extraConfig = ''
      set -as terminal-features ",foot*:RGB:bce:ccolour:clipboard:cstyle:extkeys:focus:title"
      set -g extended-keys on
      set -g focus-events on
    '';
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.fzf-tmux-url
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          set -g @vim_navigator_pattern '(\S+/)?g?\.?(view|l?n?vim?x?|fzf|\.?emacs[^/]*)(diff)?(-wrapped)?'
        '';
      }
    ];
  };
}
