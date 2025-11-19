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
    ./dconf.nix
    ../../../profiles/sway/home.nix
    ./sway.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    bun
    nodejs_24
    pkgs-unstable.opencode
    pkgs-unstable.claude-code
  ];
}
