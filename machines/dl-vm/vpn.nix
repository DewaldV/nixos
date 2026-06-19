{
  config,
  lib,
  nixos-private,
  pkgs,
  ...
}:

let
  vpn = nixos-private.private.vpn.dl-vm;
  interface = "protonvpn";
  lanCidr = "192.168.0.0/24";
  endpointParts = lib.splitString ":" vpn.peer.endpoint;
  endpointAddress = builtins.elemAt endpointParts 0;
  endpointPort = builtins.elemAt endpointParts 1;
in
{
  networking.wg-quick.interfaces.${interface} = {
    address = vpn.interface.address;
    dns = vpn.interface.dns;
    postUp = "${pkgs.systemd}/bin/resolvectl dnsovertls ${interface} no";
    privateKeyFile = config.age.secrets.dl-vm-private-key.path;
    peers = [
      {
        inherit (vpn.peer)
          allowedIPs
          persistentKeepalive
          publicKey
          ;
        endpoint = vpn.peer.endpoint;
      }
    ];
  };

  networking.firewall = {
    checkReversePath = false;
  };

  networking.nftables = {
    enable = true;
    tables.vpn-egress = {
      family = "inet";
      content = ''
        chain output {
          type filter hook output priority filter; policy accept;

          oifname "lo" accept
          ct state established,related accept
          oifname "${interface}" accept
          ip daddr ${lanCidr} accept
          ip daddr ${endpointAddress} udp dport ${endpointPort} accept
          oifname "eth0" reject
        }
      '';
    };
  };
}
