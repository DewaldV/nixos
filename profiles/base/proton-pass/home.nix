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
    proton-pass-cli
  ];

  # Use the D-Bus Secret Service (GNOME Keyring) as the keyring backend so
  # that the pass-cli encryption key persists across reboots. Requires a
  # running and unlocked Secret Service provider in the session.
  home.sessionVariables = {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  programs.zsh.shellAliases = {
    # Manual reload mid-session; auto-load is handled by the systemd service
    pass-ssh-load = "pass-cli ssh-agent load";
  };

  # Auto-load SSH keys into the agent at login. Runs after GNOME Keyring is
  # unlocked (so pass-cli can retrieve its encryption key via D-Bus) and after
  # the SSH agent is ready.
  systemd.user.services.proton-pass-ssh-load = {
    Unit = {
      Description = "Load Proton Pass SSH keys into agent";
      After = [
        "graphical-session.target"
        "gnome-keyring-daemon.service"
        "ssh-agent.service"
      ];
    };
    Service = {
      Type = "oneshot";
      Environment = [
        "PROTON_PASS_LINUX_KEYRING=dbus"
        "SSH_AUTH_SOCK=%t/ssh-agent"
      ];
      ExecStart = "${proton-pass-cli}/bin/pass-cli ssh-agent load";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
