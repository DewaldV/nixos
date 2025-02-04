{ config, pkgs, ... }:

{
  home.file.".doom.d".source = ./doom.d;

  home.packages = with pkgs; [
    # Doom Emacs requisites
    fd
    git
    findutils
    ripgrep

    # Go dev tools
    dockfmt
    errcheck
    gci
    go
    gocode-gomod
    golangci-lint
    golangci-lint-langserver
    gomodifytags
    gopls
    gore
    gotests
    gotestsum
    gotools
    go-tools
    unconvert
  ];
}
