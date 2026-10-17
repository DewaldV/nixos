{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  isDarwin,
  ...
}:

let
  proton-pass-cli = pkgs-unstable.proton-pass-cli;
in
{
  home.packages = [ proton-pass-cli ];

  # Use the D-Bus Secret Service (GNOME Keyring) as the keyring backend so
  # that the pass-cli encryption key persists across reboots. Requires a
  # running and unlocked Secret Service provider in the session.
  home.sessionVariables = lib.mkIf (!isDarwin) {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  systemd.user.targets.network-online = lib.mkIf (!isDarwin) {
    Unit = {
      Description = "Network is online";
      Requires = [ "network-online.service" ];
      After = [ "network-online.service" ];
    };
  };

  systemd.user.services.network-online = lib.mkIf (!isDarwin) {
    Unit.Description = "Wait for NetworkManager connectivity";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.networkmanager}/bin/nm-online --quiet";
      RemainAfterExit = true;
    };
  };

  # Auto-load SSH keys into the agent at login. Runs after GNOME Keyring is
  # unlocked (so pass-cli can retrieve its encryption key via D-Bus) and after
  # the SSH agent and network are ready.
  systemd.user.services.proton-pass-ssh-load = lib.mkIf (!isDarwin) {
    Unit = {
      Description = "Load Proton Pass SSH keys into agent";
      Requires = [ "network-online.target" ];
      After = [
        "graphical-session.target"
        "gnome-keyring-daemon.service"
        "ssh-agent.service"
        "network-online.target"
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
