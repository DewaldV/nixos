{ ... }:

{
  users.groups.media.gid = 2000;

  users.users.dewaldv.extraGroups = [
    "media"
  ];

  users.users.downloads = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/downloads";
    createHome = true;
  };

  services.transmission = {
    enable = true;
    user = "downloads";
    group = "media";
    openFirewall = true;
    openRPCPort = true;
    settings = {
      download-dir = "/srv/data/complete";
      incomplete-dir-enabled = true;
      incomplete-dir = "/srv/data/incomplete";
      peer-port = 51413;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.0.*";
      rpc-whitelist-enabled = true;
      watch-dir-enabled = true;
      watch-dir = "/srv/data/watch";
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/data/incomplete 2775 downloads media - -"
    "d /srv/data/watch 2775 downloads media - -"
    "d /srv/data/staging 2775 downloads media - -"
    "d /srv/data/complete 2775 downloads media - -"
  ];
}
