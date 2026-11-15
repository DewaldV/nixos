{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../../../profiles/desktop-apps/foot.nix
    ../../../profiles/development/home.nix
    ../../../profiles/editors/home.nix
    ../../../profiles/shell/home.nix
    ../../../profiles/work/home.nix
    ../../../profiles/workstation/home.nix

    # Machine-specific overrides
    ./doom
    ./git.nix
    ./zsh
  ];

  # New config
  targets.genericLinux.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Make the multi-user Nix installation available in shell sessions.
  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
  ];

  # This machine's SSH agent is the GCR one rather than ssh-agent.service.
  systemd.user.services.proton-pass-ssh-load.Service.Environment = lib.mkForce [
    "PROTON_PASS_LINUX_KEYRING=dbus"
    "SSH_AUTH_SOCK=/run/user/1000/gcr/ssh"
  ];

  home.packages = with pkgs; [
    bat
    btop
    curl
    dig
    eza
    fd
    file
    fzf
    gnumake
    htop
    jq
    lsof
    ripgrep
    tmux
    tree
    unzip
    vim
    wget
    xh

    # Nix tooling
    nixfmt
    nvd
  ];

  home.username = "dewaldv";
  home.homeDirectory = "/home/dewaldv";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  # Tool version manager
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs-unstable.mise;
  };
}
