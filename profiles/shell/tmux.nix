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
        plugin = tmuxPlugins.minimal-tmux-status;
        extraConfig = ''
          set -g @minimal-tmux-fg "#1d1f21"
          set -g @minimal-tmux-bg "#81a2be"
          set -g @minimal-tmux-justify "left"
          set -g @minimal-tmux-indicator-str " tmux "
          set -g @minimal-tmux-status "bottom"
          set -g @minimal-tmux-right true
          set -g @minimal-tmux-left true
          set -g @minimal-tmux-use-arrow true
          set -g @minimal-tmux-right-arrow ""
          set -g @minimal-tmux-left-arrow ""
        '';
      }
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          set -g @vim_navigator_pattern '(\S+/)?g?\.?(view|l?n?vim?x?|fzf|\.?emacs[^/]*)(diff)?(-wrapped)?'
        '';
      }
    ];
  };
}
