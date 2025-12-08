{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.syncthing = {
    enable = true;

    settings = {
      options = {
        globalAnnounceEnabled = false; # Disable global discovery
        relaysEnabled = false; # Disable relay servers too
        localAnnounceEnabled = true; # Keep local network discovery
      };
    };
  };
}
