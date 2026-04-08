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
      22 # SSH
      80 # HTTP (Caddy — redirects to HTTPS)
      443 # HTTPS (Caddy)
      2222 # SSH initrd unlock
    ];
    allowedUDPPorts = [
      41641 # Tailscale
    ];
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
      port = 2222;
      authorizedKeys = [ nixos-private.private.keys.personal.ssh.pub ];
      hostKeys = [
        (pkgs.writeText "initrd-ssh-host-key" nixos-private.private.keys.machines.home-srv.initrd.private)
      ];
    };
  };

  # Caddy virtual hosts
  services.caddy.virtualHosts."home-assistant.home.dewaldv.com".extraConfig = ''
    reverse_proxy http://192.168.0.2:8123
  '';

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
