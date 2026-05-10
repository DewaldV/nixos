{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../dns/quad9.nix
    ../nix
    ../sshd
    ../user/dewaldv.nix
  ];

  profiles.dns.quad9 = {
    setNameservers = true;
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

  # SSH agent
  programs.ssh.startAgent = true;

  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    e2fsprogs
    pciutils
    usbutils
  ];

}
