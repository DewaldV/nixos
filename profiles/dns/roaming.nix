{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.dns.roaming;
  policy = pkgs.writeShellApplication {
    name = "roaming-dns-policy";
    runtimeInputs = with pkgs; [
      networkmanager
      systemd
      coreutils
      util-linux
      gnugrep
    ];
    text = builtins.readFile ./roaming-dns.sh;
  };
  command = pkgs.writeShellApplication {
    name = "captive-portal";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      firefox
      networkmanager
      util-linux
    ];
    text = ''
      dns_policy=${policy}/bin/roaming-dns-policy
    ''
    + builtins.readFile ./captive-portal.sh;
  };
in
{
  options.profiles.dns.roaming.enable =
    lib.mkEnableOption "secure roaming DNS with temporary captive-portal mode";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.profiles.dns.quad9.enable
          && config.profiles.dns.quad9.dnsOverTls
          && config.profiles.dns.quad9.dnssec;
        message = "Roaming DNS requires secure Quad9 defaults.";
      }
      {
        assertion = config.networking.networkmanager.enable;
        message = "Roaming DNS requires NetworkManager.";
      }
    ];
    networking.networkmanager.dns = "systemd-resolved";
    environment.systemPackages = [ command ];
    # Also configure links already active at boot or configuration activation.
    systemd.services.roaming-dns-policy = {
      description = "Apply roaming DNS policy to active connections";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "NetworkManager.service"
        "systemd-resolved.service"
      ];
      after = [
        "NetworkManager.service"
        "systemd-resolved.service"
      ];
      partOf = [ "systemd-resolved.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [ pkgs.networkmanager ];
      script = ''
        while IFS= read -r iface; do
          [ -n "$iface" ] || continue
          ${policy}/bin/roaming-dns-policy event "$iface" reapply
        done < <(nmcli -g DEVICE connection show --active)
      '';
    };
    networking.networkmanager.dispatcherScripts = [
      {
        type = "basic";
        source = pkgs.writeShellScript "roaming-dns-dispatcher" ''
          exec ${policy}/bin/roaming-dns-policy event "$1" "$2"
        '';
      }
    ];
  };
}
