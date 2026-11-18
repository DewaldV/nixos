{
  lib,
  pkgs,
  webdavHtpasswdFile,
  ...
}:

{
  microvm.credentialFiles.webdav-htpasswd = webdavHtpasswdFile;

  systemd.services.rclone-webdav = {
    description = "WebDAV server for synced notes";
    unitConfig.RequiresMountsFor = [ "/srv/documents" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      User = "dewaldv";
      Group = "users";
      LoadCredential = "htpasswd:webdav-htpasswd";
      ExecStart = "${lib.getExe pkgs.rclone} serve webdav /srv/documents/notes --addr 192.168.0.12:8181 --htpasswd %d/htpasswd";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
