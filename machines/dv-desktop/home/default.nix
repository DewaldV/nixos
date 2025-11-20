{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  composeHome = import ../../../lib/composehome.nix;
in
{

  imports = composeHome [
    ../../../profiles/sway/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/desktop-apps/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/virtualization/home.nix
    ../../../profiles/immich/home.nix
    ./sway.nix
    ./vscode.nix
  ];

  # All packages now in profiles
}
