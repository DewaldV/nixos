{
  config,
  pkgs,
  nixos-private,
  ...
}:

{
  programs.ssh = {
    enableDefaultConfig = false;
    enable = true;

    settings = {
      # Default SSH options
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = true;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "192.168.0.10" = {
        ForwardAgent = true;
      };

      "github.com" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/personal-ed25519";
        IdentitiesOnly = true;
      };
    };
  };

  home.file.".ssh/personal-ed25519".text = nixos-private.private.keys.personal.ssh.pub;

  home.file.".ssh/allowed_signers".text =
    "${nixos-private.private.keys.personal.email} ${nixos-private.private.keys.personal.ssh.pub}";
}
