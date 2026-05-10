{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../../../profiles/activation-report/home.nix
    ../../../profiles/shell/home.nix
  ];

  home.packages = with pkgs; [
    # System monitoring
    btop
    htop

    # Network utilities
    curl
    dig
    wget

    # File utilities
    file
    tree
    unzip

    # Text processing
    jq
    vim

    # Nix tooling
    nixfmt-rfc-style
    nvd

    # System utilities
    lsof
  ];

  home.stateVersion = "25.11";
}
