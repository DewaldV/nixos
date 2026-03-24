{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  # TODO: remove once 1.8.0 reaches nixpkgs unstable
  sources = {
    "x86_64-linux" = pkgs-unstable.fetchurl {
      url = "https://proton.me/download/pass-cli/1.8.0/pass-cli-linux-x86_64";
      hash = "sha256-M7zWxVYHHjM86/l3K+0AR8QceiydP0n0sXj9rSctaeI=";
    };
    "aarch64-linux" = pkgs-unstable.fetchurl {
      url = "https://proton.me/download/pass-cli/1.8.0/pass-cli-linux-aarch64";
      hash = "sha256-t3AyOLF0mXh9eCxBOh3e8WPBPowv9pWZ2WQTCTl+StA=";
    };
  };
  # TODO: remove once 1.8.0 reaches nixpkgs unstable
  proton-pass-cli = pkgs-unstable.proton-pass-cli.overrideAttrs (old: {
    version = "1.8.0";
    src = sources.${pkgs-unstable.stdenv.hostPlatform.system};
  });
in

{
  home.packages = [
    pkgs-unstable.proton-pass
    proton-pass-cli
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
