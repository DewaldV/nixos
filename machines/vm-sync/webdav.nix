{
  lib,
  nixos-private,
  pkgs,
  webdavHtpasswdFile,
  ...
}:

let
  inherit (nixos-private.private.infrastructure) hosts ports;
in
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
      ExecStart = "${lib.getExe pkgs.rclone} serve webdav /srv/documents/notes --addr ${hosts.vm_sync}:${toString ports.webdav} --htpasswd %d/htpasswd";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
