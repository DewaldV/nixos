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
  syncthingData = nixos-private.private.syncthing;
  otherDevices = lib.filterAttrs (deviceName: _: deviceName != hostname) syncthingData.devices;
in
{
  services.syncthing = {
    enable = true;

    settings = {

      options = {
        urAccepted = 3; # Accept v3 analytics
        globalAnnounceEnabled = false; # Disable global discovery
        relaysEnabled = false; # Disable relay servers too
        localAnnounceEnabled = true; # Keep local network discovery
      };

      devices = otherDevices;

      folders = lib.mapAttrs (
        name: folder:
        folder
        // {
          devices = builtins.attrNames otherDevices;
        }
      ) syncthingData.folders;
    };
  };
}
