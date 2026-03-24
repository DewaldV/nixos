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

  # Use the D-Bus Secret Service (GNOME Keyring) as the keyring backend so
  # that the pass-cli encryption key persists across reboots. Requires a
  # running and unlocked Secret Service provider in the session.
  home.sessionVariables = {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  programs.zsh.shellAliases = {
    pass-ssh-load = "pass-cli ssh-agent load";
  };
}
