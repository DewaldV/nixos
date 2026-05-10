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
    cfg.secondaryIpv6
  ];
in
{
  options.profiles.dns.quad9 = {
    secondaryIpv6 = lib.mkOption {
      type = lib.types.str;
      default = "2620:fe::92";
      description = "Secondary Quad9 IPv6 resolver.";
    };

    setNameservers = lib.mkEnableOption "setting Quad9 as system nameservers";

    dnsOverTls = lib.mkEnableOption "Quad9 DNS-over-TLS for systemd-resolved";

  };

  config = {
    networking.nameservers = lib.mkIf cfg.setNameservers servers;

    services.resolved = {
      enable = true;
      fallbackDns = servers;
      dnssec = lib.mkIf cfg.dnsOverTls "true";
      extraConfig = lib.mkIf cfg.dnsOverTls ''
        [Resolve]
        DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
        DNSOverTLS=yes
      '';
    };
  };
}
