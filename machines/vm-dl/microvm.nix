{
  lib,
  pkgs,
  vpnPrivateKeyPath,
  ...
}:

{
  imports = [
    ../../profiles/machines/microvm
    ./transmission.nix
    ./vpn.nix
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  microvm = {
    # QEMU hangs when microvm.nix assigns exactly 2 GiB.
    mem = 2047;
    machineId = "57ad0239-244f-e74c-3463-0b75be850c46";
    credentialFiles.dl-vm-private-key = vpnPrivateKeyPath;
    vsock.cid = 4;

    interfaces = [
      {
        type = "tap";
        id = "vm-dl";
        mac = "52:54:00:00:00:11";
        tap.vhost = true;
      }
    ];

    shares = [
      {
        source = "/srv/vm-dl";
        mountPoint = "/srv/data";
        tag = "vm-dl-data";
        proto = "virtiofs";
        securityModel = "passthrough";
      }
    ];

    volumes = [
      {
        image = "vm-dl-transmission-state.img";
        mountPoint = "/var/lib/transmission";
        size = 1024;
      }
    ];

    # Join the host's LAN bridge after microvm.nix creates the TAP device.
    binScripts.tap-up = lib.mkAfter ''
      ${lib.getExe' pkgs.iproute2 "ip"} link set dev vm-dl master br0
    '';
  };

  networking = {
    useDHCP = false;
    defaultGateway = {
      address = "192.168.0.1";
      interface = "eth0";
    };
    firewall.enable = true;
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.0.11";
        prefixLength = 24;
      }
    ];
  };

  system.stateVersion = "25.11";
}
