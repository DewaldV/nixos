{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.dns.roaming;
  tools = pkgs.runCommand "roaming-dns" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p "$out/bin" "$out/lib"
    cp ${./dns_common.py} "$out/lib/dns_common.py"
    cp ${./roaming-dns.py} "$out/lib/roaming-dns.py"
    cp ${./captive-portal.py} "$out/lib/captive-portal.py"
    makeWrapper ${pkgs.python3}/bin/python3 "$out/bin/roaming-dns-policy" \
      --add-flags "$out/lib/roaming-dns.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgs.networkmanager
          pkgs.systemd
        ]
      }
    makeWrapper ${pkgs.python3}/bin/python3 "$out/bin/captive-portal" \
      --add-flags "$out/lib/captive-portal.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgs.networkmanager
          pkgs.curl
          pkgs.firefox
        ]
      }
  '';
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
    # NetworkManager can overwrite resolvectl overrides on later DNS updates.
    # Proton's resolver uses plain DNS inside the encrypted VPN tunnel.
    networking.networkmanager.settings.connection-proton = {
      match-device = "interface-name:proton*";
      "connection.dns-over-tls" = 0;
      "connection.dnssec" = 2;
    };
    environment.systemPackages = [ tools ];
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
          ${tools}/bin/roaming-dns-policy event "$iface" reapply
        done < <(nmcli -g DEVICE connection show --active)
      '';
    };
    networking.networkmanager.dispatcherScripts = [
      {
        type = "basic";
        source = pkgs.writeShellScript "roaming-dns-dispatcher" ''
          exec ${tools}/bin/roaming-dns-policy event "$1" "$2"
        '';
      }
    ];
  };
}
