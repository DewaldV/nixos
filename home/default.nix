{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../profiles/base/home.nix
    ./1password
    ./alacritty.nix
    ./direnv.nix
    ./doom
    ./editorconfig.nix
    ./foot.nix
    ./fzf.nix
    ./git.nix
    ./gtk.nix
    ./neovim.nix
    ./rust
    ./ssh.nix
    ./tmux.nix
    ./zsh
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
  };

  home.stateVersion = "22.11";

  # Note: Development tools moved to profiles/development
  # Note: Desktop apps moved to profiles/desktop-apps
  home.packages = with pkgs; [
    bat
    editorconfig-core-c
    eza
    pandoc
    pkgs-unstable.codex
    xh
    xstow
  ];
}
