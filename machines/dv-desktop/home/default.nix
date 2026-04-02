{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../../../profiles/workstation/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/sway/home.nix
    ../../../profiles/development/home.nix
    ../../../profiles/desktop-apps/home.nix
    ../../../profiles/agents/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/virtualization/home.nix
    ../../../profiles/immich/home.nix
    ../../../profiles/sync/home.nix
    ./sway.nix
  ];

  home.stateVersion = "22.11";
}
