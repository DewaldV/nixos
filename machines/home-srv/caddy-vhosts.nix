{
  config,
  nixos-private,
  ...
}:

let
  inherit (nixos-private.private.infrastructure) hosts lan ports;
  lanCidr = "${lan.address}/${toString lan.prefix_length}";
in
{
  # Caddy virtual hosts
  services.caddy.virtualHosts = {
    "furfaces.net".extraConfig = ''
      root * ${./homepage}
      file_server
    '';

    ### vm-sync
    "vm-sync.syncthing.furfaces.net".extraConfig = ''
      reverse_proxy http://${hosts.vm_sync}:${toString ports.syncthing_gui}
    '';
    "notes.furfaces.net".extraConfig = ''
      reverse_proxy http://${hosts.vm_sync}:${toString ports.webdav}
    '';

    ### Home Assistant
    "home-assistant.furfaces.net".extraConfig = ''
      reverse_proxy http://${hosts.home_assistant}
    '';

    ### home-srv
    "adguard.furfaces.net".extraConfig = ''
      reverse_proxy http://${config.services.adguardhome.settings.http.address}
    '';
    "jellyfin.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
    '';
    "immich.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString config.services.immich.port}
    '';
    "recon.furfaces.net".extraConfig = ''
      @denied not remote_ip 127.0.0.1 ::1 ${lanCidr} 100.64.0.0/10 fd7a:115c:a1e0::/48
      respond @denied "Forbidden" 403
      reverse_proxy http://${config.services.recon.listenAddress}:${toString config.services.recon.port}
    '';

    ### vm-dl
    "transmission.furfaces.net".extraConfig = ''
      reverse_proxy http://${hosts.vm_dl}:${toString ports.transmission_rpc}
    '';

    # https://www.beszel.dev/guide/reverse-proxy#caddy
    "beszel.furfaces.net".extraConfig = ''
      request_body {
        max_size 10MB
      }
      reverse_proxy http://${config.services.beszel.hub.host}:${toString config.services.beszel.hub.port} {
        transport http {
          read_timeout 360s
        }
      }
    '';

    ### vm-zeroclaw
    "zeroclaw.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString ports.zeroclaw_gateway}
    '';

    ### Router
    "router.furfaces.net".extraConfig = ''
      reverse_proxy https://${hosts.router} {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';

    ### CCTV
    "frontdoor.cctv.furfaces.net".extraConfig = ''
      reverse_proxy https://${hosts.cctv_frontdoor} {
        header_up -Via
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';

    "livingroom.cctv.furfaces.net".extraConfig = ''
      reverse_proxy https://${hosts.cctv_livingroom} {
        header_up -Via
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };

}
