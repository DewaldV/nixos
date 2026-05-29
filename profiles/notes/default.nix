{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.notes;
  gitSshCommand = "ssh -i ${cfg.sshKeyFile} -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=/etc/ssh/ssh_known_hosts";
  commonServiceConfig = {
    Type = "oneshot";
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.dataDir;
    Environment = [
      "GIT_SSH_COMMAND=${gitSshCommand}"
      "HOME=${cfg.stateDir}"
    ];
  };
in
{
  options.profiles.notes = {
    enable = lib.mkEnableOption "self-hosted notes sync";

    repository = lib.mkOption {
      type = lib.types.str;
      default = "git@github.com:dewaldv/notes.git";
      description = "Git repository containing the notes vault.";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Git branch to track for the notes vault.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/srv/notes/repo";
      description = "Path where the notes repository is checked out.";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/notes";
      description = "State directory used as HOME for git and lock files.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "notes";
      description = "User that owns and serves the notes repository.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "notes";
      description = "Group that owns and serves the notes repository.";
    };

    sshKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "SSH private key used to clone and push the notes repository.";
    };

    git = {
      authorName = lib.mkOption {
        type = lib.types.str;
        default = "home-srv notes sync";
        description = "Git author name for automated notes commits.";
      };

      authorEmail = lib.mkOption {
        type = lib.types.str;
        default = "notes@home-srv.local";
        description = "Git author email for automated notes commits.";
      };

      commitMessage = lib.mkOption {
        type = lib.types.str;
        default = "Auto-commit notes changes";
        description = "Commit message used for automated notes commits.";
      };
    };

    webdav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Serve the notes repository over WebDAV using rclone.";
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address for the local WebDAV listener.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8088;
        description = "Port for the local WebDAV listener.";
      };

      htpasswdFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Optional htpasswd file for WebDAV authentication.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      createHome = true;
    };

    environment.systemPackages = with pkgs; [
      git
      rclone
    ];

    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };

    systemd.tmpfiles.rules = [
      "d ${builtins.dirOf cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir} 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.notes-init = {
      description = "Clone notes repository if needed";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = commonServiceConfig;
      path = with pkgs; [
        git
        openssh
      ];
      script = ''
        set -euo pipefail

        if [ ! -d ${lib.escapeShellArg cfg.dataDir}/.git ]; then
          rm -rf ${lib.escapeShellArg cfg.dataDir}
          git clone --branch ${lib.escapeShellArg cfg.branch} ${lib.escapeShellArg cfg.repository} ${lib.escapeShellArg cfg.dataDir}
        fi
      '';
    };

    systemd.services.notes-update = {
      description = "Update notes repository";
      after = [
        "network-online.target"
        "notes-init.service"
      ];
      wants = [
        "network-online.target"
        "notes-init.service"
      ];
      serviceConfig = commonServiceConfig;
      path = with pkgs; [
        git
        openssh
        util-linux
      ];
      script = ''
        set -euo pipefail

        flock ${lib.escapeShellArg cfg.stateDir}/sync.lock git pull --rebase --autostash origin ${lib.escapeShellArg cfg.branch}
      '';
    };

    systemd.timers.notes-update = {
      description = "Update notes repository periodically";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "15m";
        RandomizedDelaySec = "2m";
        Unit = "notes-update.service";
      };
    };

    systemd.services.notes-commit = {
      description = "Commit and push notes repository changes";
      after = [
        "network-online.target"
        "notes-init.service"
      ];
      wants = [
        "network-online.target"
        "notes-init.service"
      ];
      serviceConfig = commonServiceConfig;
      path = with pkgs; [
        bash
        git
        openssh
        util-linux
      ];
      script = ''
        set -euo pipefail

        flock ${lib.escapeShellArg cfg.stateDir}/sync.lock bash <<'EOF'
        git add -A
        if git diff --cached --quiet; then
          exit 0
        fi

        git \
          -c user.name=${lib.escapeShellArg cfg.git.authorName} \
          -c user.email=${lib.escapeShellArg cfg.git.authorEmail} \
          commit -m ${lib.escapeShellArg cfg.git.commitMessage}
        git pull --rebase --autostash origin ${lib.escapeShellArg cfg.branch}
        git push origin HEAD:${lib.escapeShellArg cfg.branch}
        EOF
      '';
    };

    systemd.timers.notes-commit = {
      description = "Commit notes repository changes periodically";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        RandomizedDelaySec = "1m";
        Unit = "notes-commit.service";
      };
    };

    systemd.services.notes-webdav = lib.mkIf cfg.webdav.enable {
      description = "Serve notes repository over WebDAV";
      after = [ "notes-init.service" ];
      wants = [ "notes-init.service" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ rclone ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = lib.concatStringsSep " " (
          [
            "${pkgs.rclone}/bin/rclone"
            "serve"
            "webdav"
            (lib.escapeShellArg cfg.dataDir)
            "--addr"
            "${cfg.webdav.address}:${toString cfg.webdav.port}"
            "--vfs-cache-mode"
            "off"
          ]
          ++ lib.optionals (cfg.webdav.htpasswdFile != null) [
            "--htpasswd"
            (lib.escapeShellArg cfg.webdav.htpasswdFile)
          ]
        );
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
