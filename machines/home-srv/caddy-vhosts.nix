{ config, ... }:

{
  # Caddy virtual hosts
  services.caddy.virtualHosts = {
    "furfaces.net".extraConfig = ''
      root * ${./homepage}
      file_server
    '';
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
    "adguard.furfaces.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:3000
    '';
    "jellyfin.furfaces.net".extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
    "immich.furfaces.net".extraConfig = ''
      reverse_proxy http://localhost:2283
    '';
    "router.furfaces.net".extraConfig = ''
      reverse_proxy https://192.168.0.1 {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
    "frontdoor.cctv.furfaces.net".extraConfig = ''
      reverse_proxy https://192.168.0.201 {
        header_up -Via
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };

}
