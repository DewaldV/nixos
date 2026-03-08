{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.proton-pass
    pkgs-unstable.proton-pass-cli
  ];

  # Workaround: pass-cli stores its local encryption key in the kernel user
  # keyring, which is wiped on reboot. Login is required after each reboot
  # before SSH keys can be loaded.
  programs.zsh.shellAliases = {
    pass-ssh-load = "pass-cli login && pass-cli ssh-agent load";
  };
}
