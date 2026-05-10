{ lib, isDarwin, ... }:

{
  imports = [
    ./fzf.nix
    ./tmux.nix
    ./zsh
  ]
  ++ lib.optionals (!isDarwin) [ ./linux.nix ];
}
