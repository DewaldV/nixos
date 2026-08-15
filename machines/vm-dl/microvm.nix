{
  lib,
  beszelAgentEnvironmentFile,
  nixos-private,
  pkgs,
  vpnPrivateKeyPath,
  ...
}:

{
  imports = [
    ../../profiles/sshd
    ../../profiles/user/dewaldv.nix
    ./transmission.nix
    ./vpn.nix
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  microvm = {
    vcpu = 1;
    # QEMU hangs when microvm.nix assigns exactly 2 GiB.
    mem = 2047;
    machineId = "57ad0239-244f-e74c-3463-0b75be850c46";
    credentialFiles = {
      beszel-agent-env = beszelAgentEnvironmentFile;
      dl-vm-private-key = vpnPrivateKeyPath;
    };
    vsock = {
      cid = 4;
      ssh.enable = true;
    };

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
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
        readOnly = true;
      }
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

  services.beszel.agent = {
    enable = true;
    environment = {
      DISABLE_SSH = "true";
      SYSTEM_NAME = "vm-dl";
    };
    environmentFile = "/run/credentials/beszel-agent.service/beszel-agent-env";
  };

  systemd.services.beszel-agent.serviceConfig.ImportCredential = "beszel-agent-env";

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
