{
  lib,
  nixos-private,
  pkgs,
  pkgs-unstable,
  syncthingCertFile,
  syncthingKeyFile,
  syncthingGuiPasswordFile,
  webdavHtpasswdFile,
  ...
}:

let
  syncthingConfig = nixos-private.private.syncthing;
in
{
  imports = [
    ../../profiles/machines/microvm
    ../../profiles/sshd
    ../../profiles/user/dewaldv.nix
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  microvm = {
    vcpu = 1;
    mem = 1024;
    machineId = "7c08c672-74d4-44a0-ab7c-9f77308fc904";
    credentialFiles = {
      syncthing-cert = syncthingCertFile;
      syncthing-key = syncthingKeyFile;
      webdav-htpasswd = webdavHtpasswdFile;
      syncthing-gui-password = syncthingGuiPasswordFile;
    };
    vsock = {
      cid = 5;
      ssh.enable = true;
    };

    interfaces = [
      {
        type = "tap";
        id = "vm-sync";
        mac = "52:54:00:00:00:12";
        tap.vhost = true;
      }
    ];

    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
        readOnly = true;
      }
      {
        source = "/srv/vm-sync";
        mountPoint = "/srv/documents";
        tag = "vm-sync-data";
        proto = "virtiofs";
        securityModel = "passthrough";
      }
    ];

    # Keep the Tailnet identity when the MicroVM's root filesystem is rebuilt.
    volumes = [
      {
        image = "vm-sync-tailscale-state.img";
        mountPoint = "/var/lib/tailscale";
        size = 128;
      }
    ];

    binScripts.tap-up = lib.mkAfter ''
      ${lib.getExe' pkgs.iproute2 "ip"} link set dev vm-sync master br0
    '';
  };

  networking = {
    useDHCP = false;
    defaultGateway = {
      address = "192.168.0.1";
      interface = "eth0";
    };
    nameservers = [ "192.168.0.10" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8181 # WebDAV
        8384 # Syncthing GUI
      ];
    };
    nftables = {
      enable = true;
      tables.webdav-ingress = {
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority -10; policy accept;
            # Syncthing's configuration updater contacts the GUI via the VM's
            # own LAN address, which the kernel routes over loopback.
            iifname != "lo" tcp dport { 8181, 8384 } ip saddr != 192.168.0.10 reject
          }
        '';
      };
    };
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.0.12";
        prefixLength = 24;
      }
    ];
  };

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "client";
  };

  services.syncthing = {
    enable = true;
    user = "dewaldv";
    group = "users";
    dataDir = "/srv/documents/syncthing";
    guiAddress = "192.168.0.12:8384";
    guiPasswordFile = "/run/credentials/syncthing-init.service/gui-password";
    # Unit credentials are accessible to the service, unlike @system credentials
    # inside Syncthing's sandboxed ExecStartPre.
    cert = "/run/credentials/syncthing.service/syncthing-cert";
    key = "/run/credentials/syncthing.service/syncthing-key";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      options = {
        urAccepted = 3;
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        localAnnounceEnabled = true;
      };
      gui.user = "dewaldv";
      devices = lib.getAttrs [ "dv-desktop" "dv-fw" "dv-pi5" ] syncthingConfig.devices;
      folders.notes = {
        inherit (syncthingConfig.folders.notes) id;
        path = "/srv/documents/notes";
        devices = [
          "dv-desktop"
          "dv-fw"
          "dv-pi5"
        ];
      };
      folders.financial = {
        inherit (syncthingConfig.folders.financial) id;
        path = "/srv/documents/financial";
        type = "receiveonly";
        devices = [
          "dv-desktop"
          "dv-fw"
          "dv-pi5"
        ];
      };
    };
  };

  systemd.services.syncthing.unitConfig.RequiresMountsFor = [ "/srv/documents" ];
  systemd.services.syncthing.serviceConfig.LoadCredential = [
    "syncthing-cert"
    "syncthing-key"
  ];
  systemd.services.syncthing-init.serviceConfig.LoadCredential =
    "gui-password:syncthing-gui-password";

  systemd.services.rclone-webdav = {
    description = "WebDAV server for synced notes";
    unitConfig.RequiresMountsFor = [ "/srv/documents" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      User = "dewaldv";
      Group = "users";
      LoadCredential = "htpasswd:webdav-htpasswd";
      ExecStart = "${lib.getExe pkgs.rclone} serve webdav /srv/documents/notes --addr 192.168.0.12:8181 --htpasswd %d/htpasswd";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  # Match the host UID for the writable virtiofs share.
  users.users.dewaldv.uid = 1000;
  users.users.dewaldv.openssh.authorizedKeys.keys = [ nixos-private.private.keys.personal.ssh.pub ];
  users.users.root.openssh.authorizedKeys.keys = [ nixos-private.private.keys.personal.ssh.pub ];

  system.stateVersion = "25.11";
}
