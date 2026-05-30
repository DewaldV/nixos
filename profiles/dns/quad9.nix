{
  config,
  lib,
  ...
}:

let
  cfg = config.profiles.dns.quad9;
  servers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];
in
{
  options.profiles.dns.quad9 = {
    enable = lib.mkEnableOption "setting Quad9 as system nameservers";
    dnsOverTls = lib.mkEnableOption "Quad9 DNS-over-TLS for systemd-resolved";
  };

  config = {
    networking.nameservers = lib.mkIf cfg.enable servers;

    services.resolved = {
      enable = true;
      settings = lib.mkIf cfg.enable {
        Resolve = {
          DNS = "9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net";
          FallbackDNS = servers;
          DNSSEC = lib.mkIf cfg.dnsOverTls "true";
          DNSOverTLS = "yes";
        };
      };
    };
  };
}
