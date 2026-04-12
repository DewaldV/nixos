{
  lib,
  modulesPath,
  nixos-private,
  pkgs,
  ...
}:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking.hostName = "nixos-installer";
  networking.useDHCP = lib.mkForce true;

  # SSH access during installation
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      nixos-private.private.keys.personal.ssh.pub
    ];
  };

  # Allow wheel without password so nixos-install can sudo
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    btrfs-progs
    cryptsetup
    git
    parted
    vim
  ];
}
