{ ... }:

{
  # Workaround for memory leak in microsoft-identity-broker:
  # restart the service every 2 hours.
  systemd.user.services.restart-microsoft-identity-broker = {
    Unit = {
      Description = "Restart Microsoft Identity Broker Service";
      After = [ "microsoft-identity-broker.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/usr/bin/systemctl restart --user microsoft-identity-broker.service";
    };
  };

  systemd.user.timers.restart-microsoft-identity-broker = {
    Unit = {
      Description = "Restart Microsoft Identity Broker every 2 hours";
      Requires = [ "restart-microsoft-identity-broker.service" ];
    };
    Timer = {
      OnBootSec = "2h";
      OnUnitActiveSec = "2h";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
