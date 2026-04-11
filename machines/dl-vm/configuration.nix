{ nixos-private, pkgs, ... }:

{
  networking.hostName = "dl-vm";
  networking.useDHCP = false;

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
  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];

  networking.firewall.enable = true;

  boot.kernelParams = [ "net.ifnames=0" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  services.resolved = {
    enable = true;
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    dnssec = "true";
    extraConfig = ''
      [Resolve]
      DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
      DNSOverTLS=yes
    '';
  };

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console.keyMap = "us";

  programs.zsh.enable = true;

  users.groups.media.gid = 2000;

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [
      "wheel"
      "media"
    ];
    shell = pkgs.zsh;
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
