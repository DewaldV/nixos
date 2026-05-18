{ nixos-private, pkgs, ... }:

{
  networking.useDHCP = false;

  profiles.dns.quad9 = {
    enable = true;
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

  users.users.dewaldv = {
    openssh.authorizedKeys.keys = [
      nixos-private.private.keys.personal.ssh.pub
    ];
  };

  fileSystems."/srv/data" = {
    device = "dl-vm-data";
    fsType = "virtiofs";
  };

  system.stateVersion = "25.11";
}
