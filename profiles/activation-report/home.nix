{ config, pkgs, ... }:

{
  # Show diff before activation
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    if [[ -e $HOME/.local/state/nix/profiles/home-manager ]]; then
      echo "--- diff to previous home-manager generation"
      ${pkgs.nvd}/bin/nvd diff $HOME/.local/state/nix/profiles/home-manager $newGenPath
      echo "---"
    fi
  '';
}
