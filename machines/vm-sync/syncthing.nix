{
  lib,
  nixos-private,
  syncthingCertFile,
  syncthingKeyFile,
  syncthingGuiPasswordFile,
  ...
}:

let
  syncthingConfig = nixos-private.private.syncthing;
in
{
  microvm.credentialFiles = {
    syncthing-cert = syncthingCertFile;
    syncthing-key = syncthingKeyFile;
    syncthing-gui-password = syncthingGuiPasswordFile;
  };

  services.syncthing = {
    enable = true;
    user = "dewaldv";
    group = "users";
    dataDir = "/srv/documents/syncthing";
    guiAddress = "192.168.0.12:8384";
    guiPasswordFile = "/run/credentials/syncthing-init.service/gui-password";
    # Unit credentials are accessible to the service, unlike @system credentials
    # inside Syncthing's sandboxed ExecStartPre.
    cert = "/run/credentials/syncthing.service/syncthing-cert";
    key = "/run/credentials/syncthing.service/syncthing-key";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      options = {
        urAccepted = 3;
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        localAnnounceEnabled = true;
      };
      gui.user = "dewaldv";
      devices = lib.getAttrs [ "dv-desktop" "dv-fw" ] syncthingConfig.devices;
      folders.notes = {
        inherit (syncthingConfig.folders.notes) id;
        path = "/srv/documents/notes";
        devices = [
          "dv-desktop"
          "dv-fw"
        ];
      };
      folders.financial = {
        inherit (syncthingConfig.folders.financial) id;
        path = "/srv/documents/financial";
        devices = [
          "dv-desktop"
          "dv-fw"
        ];
      };
    };
  };

  systemd.services.syncthing.unitConfig.RequiresMountsFor = [ "/srv/documents" ];
  systemd.services.syncthing.serviceConfig.LoadCredential = [
    "syncthing-cert"
    "syncthing-key"
  ];
  systemd.services.syncthing-init.serviceConfig.LoadCredential =
    "gui-password:syncthing-gui-password";
}
