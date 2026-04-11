{
  config,
  lib,
  nixos-private,
  pkgs,
  ...
}:

{
  networking.hostName = "home-srv";

  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.0.10";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.0.1";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      2222 # SSH initrd unlock
    ];
  };

  services.tailscale.useRoutingFeatures = "both";

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
      port = 2222;
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
  ];

  # Caddy virtual hosts
  services.caddy.virtualHosts = {
    "furfaces.net".extraConfig = ''
      root * ${./homepage}
      file_server
    '';
    "portainer.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:9000
    '';
    "z2mqtt.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:8080
    '';
    "dv-pi5.syncthing.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:8384
    '';
    "home-assistant.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:8123
    '';
    "jellyfin.furfaces.net".extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
    "immich.furfaces.net".extraConfig = ''
      reverse_proxy http://localhost:2283
    '';

  };

  # Static IP in the initrd via systemd-networkd
  boot.initrd.systemd.network = {
    enable = true;
    networks."10-eno1" = {
      matchConfig.Name = "eno1";
      addresses = [ { Address = "192.168.0.10/24"; } ];
      routes = [ { Gateway = "192.168.0.1"; } ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
