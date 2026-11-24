{ ... }:

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
        IdentitiesOnly = true;
      };
    };
  };
}
