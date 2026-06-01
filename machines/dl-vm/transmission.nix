{ ... }:

let
  baseDir = "/srv/data";
  downloadDir = "${baseDir}/complete";
  incompleteDir = "${baseDir}/incomplete";
  watchDir = "${baseDir}/watch";
  stagingDir = "${baseDir}/staging";
in
{
  users = {
    groups.media.gid = 2000;

    users.dewaldv.extraGroups = [
      "media"
    ];

    users.downloads = {
      isSystemUser = true;
      group = "media";
      home = "/var/lib/downloads";
      createHome = true;
    };
  };

  services.transmission = {
    enable = true;
    user = "downloads";
    group = "media";
    openFirewall = true;
    openRPCPort = true;
    settings = {
      download-dir = downloadDir;
      incomplete-dir-enabled = true;
      incomplete-dir = incompleteDir;
      peer-port = 51413;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.0.*";
      rpc-whitelist-enabled = true;
      watch-dir-enabled = true;
      watch-dir = watchDir;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${downloadDir} 2775 downloads media - -"
    "d ${incompleteDir} 2775 downloads media - -"
    "d ${watchDir} 2775 downloads media - -"
    "d ${stagingDir} 2775 downloads media - -"
  ];
}
