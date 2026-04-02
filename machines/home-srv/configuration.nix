{
  config,
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
    ];
    allowedUDPPorts = [
      41641 # Tailscale
    ];
  };

  console.keyMap = "us";

  # Allow SSH access with personal key
  users.users.dewaldv.openssh.authorizedKeys.keys = [
    nixos-private.private.keys.personal.ssh.pub
  ];
}
