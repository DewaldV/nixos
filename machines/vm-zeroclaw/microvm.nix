{
  nixos-private,
  zeroclaw,
  ...
}:

let
  inherit (nixos-private.private.infrastructure) hosts lan ports;
  lanCidr = "${lan.address}/${toString lan.prefix_length}";
in
{
  imports = [
    ../../profiles/machines/microvm
    zeroclaw.nixosModules.default
    ./zeroclaw.nix
  ];

  microvm = {
    # QEMU hangs when microvm.nix assigns exactly 2 GiB.
    mem = 2047;
    machineId = "35d02f68-7aad-05a6-08e7-169c899af18e";
    vsock.cid = 3;

    interfaces = [
      {
        type = "user";
        id = "vm-zeroclaw";
        mac = "52:54:00:00:00:13";
      }
    ];

    forwardPorts = [
      {
        host.address = "127.0.0.1";
        host.port = ports.zeroclaw_gateway;
        guest.port = ports.zeroclaw_gateway;
      }
    ];

    volumes = [
      {
        image = "zeroclaw-state.img";
        mountPoint = "/var/lib/zeroclaw-main";
        size = 2048;
      }
    ];
  };

  networking.useDHCP = true;
  networking.nameservers = [ hosts.home_srv ];

  networking.nftables = {
    enable = true;
    tables.lan-egress = {
      family = "inet";
      content = ''
        chain output {
          type filter hook output priority filter; policy accept;

           ip daddr ${hosts.router} accept
           ip daddr ${hosts.home_srv} udp dport 53 accept
           ip daddr ${hosts.home_srv} tcp dport 53 accept
           ip daddr ${hosts.home_srv} tcp dport 443 accept
           ip daddr ${lanCidr} reject
         }
      '';
    };
  };

  system.stateVersion = "25.11";
}
