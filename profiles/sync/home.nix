{
  config,
  pkgs,
  lib,
  osConfig,
  nixos-private,
  ...
}:

let
  hostname = osConfig.networking.hostName or (builtins.getEnv "HOSTNAME");
  syncthingConfig = nixos-private.private.syncthing;
  peers = lib.filterAttrs (deviceName: _: deviceName != hostname) syncthingConfig.devices;

  cert = config.age.secrets."syncthing-${hostname}-cert".path;
  key = config.age.secrets."syncthing-${hostname}-key".path;
in
{
  services.syncthing = {
    enable = true;

    cert = cert;
    key = key;

    settings = {

      options = {
        urAccepted = 3; # Accept v3 analytics
        globalAnnounceEnabled = false; # Disable global discovery
        relaysEnabled = false; # Disable relay servers too
        localAnnounceEnabled = true; # Keep local network discovery
      };

      devices = peers;

      folders = lib.mapAttrs (
        name: folder:
        folder
        // {
          devices = builtins.attrNames peers;
        }
      ) syncthingConfig.folders;
    };
  };
}
