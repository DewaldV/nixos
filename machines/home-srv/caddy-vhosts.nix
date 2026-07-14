{ config, ... }:

{
  # Caddy virtual hosts
  services.caddy.virtualHosts = {
    "furfaces.net".extraConfig = ''
      root * ${./homepage}
      file_server
    '';

    ### pi5
    "portainer.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:9000
    '';
    "z2mqtt.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:8080
    '';
    "dv-pi5.syncthing.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:8384
    '';
    "home-assistant.furfaces.net".extraConfig = ''
      reverse_proxy http://192.168.0.2:8123
    '';

    ### home-srv
    "adguard.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:3000
    '';
    "jellyfin.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
    '';
    "immich.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:2283
    '';

    # https://www.beszel.dev/guide/reverse-proxy#caddy
    "beszel.furfaces.net".extraConfig = ''
      request_body {
        max_size 10MB
      }
      reverse_proxy http://127.0.0.1:8090 {
        transport http {
          read_timeout 360s
        }
      }
    '';

    ### openclaw-vm
    "openclaw.furfaces.net".extraConfig = ''
      reverse_proxy http://10.50.0.2:18789
    '';

    ### Router
    "router.furfaces.net".extraConfig = ''
      reverse_proxy https://192.168.0.1 {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';

    ### CCTV
    "frontdoor.cctv.furfaces.net".extraConfig = ''
      reverse_proxy https://192.168.0.201 {
        header_up -Via
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';

    "livingroom.cctv.furfaces.net".extraConfig = ''
      reverse_proxy https://192.168.0.202 {
        header_up -Via
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };

}
