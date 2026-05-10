{ nixos-private, pkgs, ... }:

{
  networking.useDHCP = false;

  profiles.dns.quad9 = {
    setNameservers = true;
    dnsOverTls = true;
  };

  networking.interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.0.11";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.0.1";
  networking.firewall.enable = true;

  boot.kernelParams = [ "net.ifnames=0" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console.keyMap = "us";

  users.groups.media.gid = 2000;

  users.users.dewaldv = {
    extraGroups = [
      "media"
    ];
    openssh.authorizedKeys.keys = [
      nixos-private.private.keys.personal.ssh.pub
    ];
  };

  users.users.downloads = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/downloads";
    createHome = true;
  };

  fileSystems."/srv/data" = {
    device = "dl-vm-data";
    fsType = "virtiofs";
  };

  systemd.tmpfiles.rules = [
    "d /srv/data/incomplete 2775 downloads media - -"
    "d /srv/data/staging 2775 downloads media - -"
    "d /srv/data/complete 2775 downloads media - -"
  ];

  system.stateVersion = "25.11";
}
