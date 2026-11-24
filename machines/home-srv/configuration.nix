{
  config,
  nixos-private,
  ...
}:

let
  inherit (nixos-private.private.infrastructure) hosts lan;
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

  # Keep host DNS available for recovery when AdGuard is down.
  profiles.dns.quad9 = {
    enable = true;
    dnsOverTls = true;
    dnssec = true;
  };

  # resolv.conf clients also use resolved's TLS transport. AdGuard binds other addresses.
  services.resolved.settings.Resolve.DNSStubListener = "yes";

  # timesyncd does not discover an online link with this host's unmanaged networking.
  services.chrony.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # Caddy HTTP
      443 # Caddy HTTPS
    ];
  };

  services.tailscale = {
    useRoutingFeatures = "both";
    # Preserve the host's independent Quad9 resolver policy.
    extraSetFlags = [ "--accept-dns=false" ];
  };

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
}
