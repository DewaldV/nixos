{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    dig
    eza
    fd
    file
    fzf
    htop
    jq
    lsof
    ripgrep
    tmux
    tree
    unzip
    vim
    wget
    xh
    zsh
  ];
}
