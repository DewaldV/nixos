{
  config,
  lib,
  beszelAgentEnvironmentFile,
  nixos-private,
  ...
}:

{
  imports = [
    ../../sshd
    ../../user/dewaldv.nix
  ];

  microvm = {
    vcpu = lib.mkDefault 1;
    credentialFiles.beszel-agent-env = beszelAgentEnvironmentFile;
    vsock.ssh.enable = true;

    shares = lib.mkBefore [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
        readOnly = true;
      }
    ];
  };

  services.beszel.agent = {
    enable = true;
    environment = {
      DISABLE_SSH = "true";
      SYSTEM_NAME = config.networking.hostName;
    };
    environmentFile = "/run/credentials/@system/beszel-agent-env";
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [ nixos-private.private.keys.personal.ssh.pub ];
    dewaldv.openssh.authorizedKeys.keys = [ nixos-private.private.keys.personal.ssh.pub ];
  };

  security.sudo.extraRules = [
    {
      users = [ "dewaldv" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
