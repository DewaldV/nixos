{ lib, ... }:

{
  programs.tmux.extraConfig = lib.mkAfter ''
    set -as terminal-features ",foot*:RGB:bce:ccolour:clipboard:cstyle:extkeys:focus:title"
  '';
}
