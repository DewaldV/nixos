{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
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

  home.packages = with pkgs; [
    argocd
    awscli2
    bat
    brave
    editorconfig-core-c
    eza
    flameshot
    google-cloud-sdk
    helvum
    k9s
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    libreoffice-fresh
    pandoc
    pre-commit
    shellcheck
    shfmt
    ssm-session-manager-plugin
    tflint
    tflint-plugins.tflint-ruleset-aws
    pkgs-unstable.codex
    xh
    xstow
  ];
}
