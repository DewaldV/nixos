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
    "jellyfin.furfaces.net".extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
    "immich.furfaces.net".extraConfig = ''
      reverse_proxy http://localhost:2283
    '';
    "router.furfaces.net".extraConfig = ''
      reverse_proxy https://192.168.0.1
    '';
  };

}
