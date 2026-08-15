{
  config,
  nixos-private,
  ...
}:

{
  users.groups.media.gid = 2000;
  users.users.dewaldv.extraGroups = [ "media" ];

  age.secrets.dl-vm-private-key = {
    owner = "microvm";
    group = "kvm";
  };

  systemd.tmpfiles.rules = [
    "d /srv/vm-dl 2775 root media - -"
    "d /srv/vm-dl/incomplete 2775 root media - -"
    "d /srv/vm-dl/staging 2775 root media - -"
    "d /srv/vm-dl/complete 2775 root media - -"
    "d /srv/vm-dl/watch 2775 root media - -"
  ];

  microvm.vms.vm-dl = {
    specialArgs = {
      inherit nixos-private;
      beszelAgentEnvironmentFile = config.age.secrets.beszel-agent-env.path;
      vpnPrivateKeyPath = config.age.secrets.dl-vm-private-key.path;
    };
    config = import ../../vm-dl/microvm.nix;
  };
}
