{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../../../profiles/shell/home.nix
  ];

  # Show diff before activation
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    if [[ -e $HOME/.local/state/nix/profiles/home-manager ]]; then
      echo "--- diff to previous home-manager generation"
      ${pkgs.nvd}/bin/nvd diff $HOME/.local/state/nix/profiles/home-manager $newGenPath
      echo "---"
    fi
  '';

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
