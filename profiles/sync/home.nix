{
  config,
  pkgs,
  lib,
  nixos-private,
  ...
}:

let
  syncthingData = nixos-private.private.syncthing;
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

      devices = syncthingData.devices;

      folders = lib.mapAttrs (
        name: folder:
        folder
        // {
          devices = builtins.attrNames syncthingData.devices;
        }
      ) syncthingData.folders;
    };
  };
}
