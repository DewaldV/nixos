{
  zeroclaw,
  ...
}:

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
        host.port = 42617;
        guest.port = 42617;
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
  networking.nameservers = [ "192.168.0.10" ];

  networking.nftables = {
    enable = true;
    tables.lan-egress = {
      family = "inet";
      content = ''
        chain output {
          type filter hook output priority filter; policy accept;

           ip daddr 192.168.0.1 accept
           ip daddr 192.168.0.10 udp dport 53 accept
           ip daddr 192.168.0.10 tcp dport 53 accept
           ip daddr 192.168.0.10 tcp dport 443 accept
           ip daddr 192.168.0.0/24 reject
         }
      '';
    };
  };

  system.stateVersion = "25.11";
}
