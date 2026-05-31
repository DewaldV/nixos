{
  lib,
  nixos-private,
  ...
}:

{
  networking.useDHCP = false;

  networking.interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "10.50.0.2";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "10.50.0.1";
  networking.firewall.enable = true;

  boot.kernelParams = [ "net.ifnames=0" ];

  services.qemuGuest.enable = true;

  console.keyMap = "us";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  users.users = {
    root.openssh.authorizedKeys.keys = [ nixos-private.private.keys.personal.ssh.pub ];
    dewaldv.openssh.authorizedKeys.keys = [ nixos-private.private.keys.personal.ssh.pub ];
  };

  system.stateVersion = "25.11";
}
