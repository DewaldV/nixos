{
  config,
  nixos-private,
  ...
}:

{
  # Decrypted only on the host, then injected into the guest at runtime.
  age.secrets.vm-sync-syncthing-cert = {
    owner = "microvm";
    group = "kvm";
  };
  age.secrets.vm-sync-syncthing-key = {
    owner = "microvm";
    group = "kvm";
  };
  age.secrets.vm-sync-webdav-htpasswd = {
    owner = "microvm";
    group = "kvm";
  };
  age.secrets.vm-sync-gui-password = {
    owner = "microvm";
    group = "kvm";
  };

  systemd.tmpfiles.rules = [
    "d /srv/vm-sync 0700 dewaldv users - -"
    "d /srv/vm-sync/notes 0700 dewaldv users - -"
    "d /srv/vm-sync/financial 0700 dewaldv users - -"
    "d /srv/vm-sync/syncthing 0700 dewaldv users - -"
  ];

  microvm.vms.vm-sync = {
    specialArgs = {
      inherit nixos-private;
      syncthingCertFile = config.age.secrets.vm-sync-syncthing-cert.path;
      syncthingKeyFile = config.age.secrets.vm-sync-syncthing-key.path;
      webdavHtpasswdFile = config.age.secrets.vm-sync-webdav-htpasswd.path;
      syncthingGuiPasswordFile = config.age.secrets.vm-sync-gui-password.path;
    };
    config = import ../../vm-sync/microvm.nix;
  };
}
