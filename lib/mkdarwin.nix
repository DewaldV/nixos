name:
{
  nix-darwin,
  home-manager,
  nixos-private,
  nixpkgs,
  nixpkgs-unstable,
  system,
  username,
  homeDirectory ? "/Users/${username}",
}:

let
  inherit (import ./mk-package-sets.nix { inherit nixpkgs nixpkgs-unstable system; }) pkgs-unstable;
  homeConfig = import ./mk-home-config.nix name {
    lib = nixpkgs.lib;
    inherit nixos-private pkgs-unstable system;
  };
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit nixos-private pkgs-unstable;
  };

  modules = [
    ../profiles/core-tools
    ../machines/${name}

    home-manager.darwinModules.home-manager
    {
      users.users.${username}.home = homeDirectory;
      home-manager = homeConfig.forUser username;
    }
    (
      { config, pkgs, ... }:
      {
        system.activationScripts.preActivation.text = ''
          if [[ -e /run/current-system ]]; then
            echo "--- diff to current-system"
            ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
            echo "---"
          fi
        '';
      }
    )
  ];
}
