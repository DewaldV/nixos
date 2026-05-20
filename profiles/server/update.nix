{ config, ... }:

{
  age.secrets.nixos-update-readonly-key = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

  programs.ssh.knownHosts.github = {
    hostNames = [ "github.com" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ${config.age.secrets.nixos-update-readonly-key.path}
      IdentitiesOnly yes
  '';

  system.autoUpgrade = {
    enable = true;
    operation = "boot";
    flake = "github:dewaldv/nixos/stable#${config.networking.hostName}";
    dates = "Sun *-*-* 03:00:00";
    randomizedDelaySec = "1h";
    fixedRandomDelay = true;
    allowReboot = false;
  };
}
