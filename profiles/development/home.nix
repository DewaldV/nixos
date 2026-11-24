{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Development tool configurations
  imports = [
    ./direnv.nix
    ./git.nix
    ./personal-identity.nix
    ./rust
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    # Version control & CLI tools
    gh

    # Development utilities
    pkgs-unstable.devenv

    # Shell dev
    shellcheck
    shfmt

    # Languages
    python314
    uv

    # Go development tools
    dockfmt
    errcheck
    gci
    pkgs-unstable.go
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
