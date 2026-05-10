name:
{
  nix-darwin,
  home-manager,
  nixos-private,
  nixpkgs,
  nixpkgs-unstable,
  system,
}:

let
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  isDarwin = nixpkgs.lib.hasSuffix "-darwin" system;
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit nixos-private pkgs-unstable;
  };

  modules = [
    ../machines/${name}

    home-manager.darwinModules.home-manager
    {

      users.users."dewald.viljoen".home = "/Users/dewald.viljoen";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users."dewald.viljoen" =
        {
          ...
        }:
        {
          imports = [
            ../profiles/activation-report/home.nix
            nixos-private.homeManagerModule
            ../machines/${name}/home
          ];

        };
      home-manager.extraSpecialArgs = {
        inherit nixos-private pkgs-unstable isDarwin;
      };
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
