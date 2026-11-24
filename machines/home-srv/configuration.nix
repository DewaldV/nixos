{
  config,
  lib,
  nixos-private,
  pkgs,
  ...
}:

let
  inherit (nixos-private.private.infrastructure) hosts lan ports;
in
{
  networking.interfaces.eno1.useDHCP = false;

  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = hosts.home_srv;
        prefixLength = lan.prefix_length;
      }
    ];
  };

  networking.bridges.br0.interfaces = [ "eno1" ];

  networking.defaultGateway = {
    address = hosts.router;
    interface = "br0";
  };

  # timesyncd does not discover an online link with this host's unmanaged networking.
  services.chrony.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # Caddy HTTP
      443 # Caddy HTTPS
      config.boot.initrd.network.ssh.port
    ];
  };

  services.tailscale.useRoutingFeatures = "both";

  services.beszel = {
    hub = {
      enable = true;
      environment = {
        APP_URL = "https://beszel.furfaces.net";
      };
    };
    agent = {
      enable = true;
      environmentFile = config.age.secrets.beszel-agent-env.path;
      smartmon.enable = true;
    };
  };

  console.keyMap = "us";

  system.stateVersion = "25.11";

  # Allow SSH access with personal key
  users.users.dewaldv.openssh.authorizedKeys.keys = [
    nixos-private.private.keys.personal.ssh.pub
  ];

  # Initrd SSH unlock
  # Allows remote LUKS passphrase entry on boot before the filesystem is mounted.
  # The host key is stored unencrypted in the Nix store — this is intentional and safe.
  # Its only purpose is to prevent MITM on the initrd SSH connection; it holds no secrets.
  # Generate with: ssh-keygen -t ed25519 -N "" -f machines/home-srv/initrd-ssh-host-key
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = ports.initrd_ssh;
      authorizedKeys = [ nixos-private.private.keys.personal.ssh.pub ];
      hostKeys = [
        (pkgs.writeText "initrd-ssh-host-key" nixos-private.private.keys.machines.home-srv.initrd.private)
      ];
    };
  };

  # Give jellyfin read access to the media library
  users.users.jellyfin.extraGroups = [ "media" ];
  users.groups.media = { };
  systemd.tmpfiles.rules = [
    "d /mnt/media 0755 root media - -"
    "d /srv/home-automation 0700 dewaldv users - -"
    "d /srv/home-automation/home-assistant 0700 dewaldv users - -"
    "d /srv/home-automation/zigbee2mqtt 0700 dewaldv users - -"
  ];

  # Containers are started manually after migrating state from dv-pi5.
  environment.etc."home-automation/compose.yaml".source = ./home-automation/compose.yaml;
  environment.etc."home-automation/mosquitto.conf".source = ./home-automation/mosquitto.conf;

  # Static IP in the initrd via systemd-networkd
  boot.initrd.systemd.network = {
    enable = true;
    networks."10-eno1" = {
      matchConfig.Name = "eno1";
      addresses = [ { Address = "${hosts.home_srv}/${toString lan.prefix_length}"; } ];
      routes = [ { Gateway = hosts.router; } ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
