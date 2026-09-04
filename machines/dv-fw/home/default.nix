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
    ../../../profiles/agents/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/sync/home.nix
    ../../../profiles/ovh/home.nix
    ./sway.nix
  ];

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    pkgs-unstable.amdtop
  ];
}
