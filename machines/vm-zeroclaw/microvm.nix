{
  nixos-private,
  pkgs-unstable,
  zeroclaw,
  ...
}:

{
  imports = [
    ../../profiles/sshd
    ../../profiles/user/dewaldv.nix
    zeroclaw.nixosModules.default
    ./zeroclaw.nix
  ];

  microvm = {
    vcpu = 1;
    # QEMU hangs when microvm.nix assigns exactly 2 GiB.
    mem = 2047;

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

    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
        readOnly = true;
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
          ip daddr 192.168.0.0/24 reject
        }
      '';
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      nixos-private.private.keys.personal.ssh.pub
    ];

    dewaldv.openssh.authorizedKeys.keys = [
      nixos-private.private.keys.personal.ssh.pub
    ];
  };

  system.stateVersion = "25.11";
}
