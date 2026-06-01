{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../dns
    ../nix
    ../sshd
    ../user/dewaldv.nix
    ./update.nix
  ];

  profiles.dns.quad9 = {
    enable = true;
    dnsOverTls = true;
  };

  # Boot
  boot = {
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
  };

  # Networking
  networking.networkmanager.enable = false;

  # Timezone and Locale
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console.keyMap = "us";

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    e2fsprogs
    pciutils
    usbutils
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/agenix 0700 root root - -"
  ];
}
