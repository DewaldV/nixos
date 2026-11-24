{
  config,
  nixos-private,
  ...
}:

let
  inherit (nixos-private.private.infrastructure) hosts lan;
in
{
  networking.firewall = {
    allowedTCPPorts = [ config.services.adguardhome.settings.dns.port ];
    allowedUDPPorts = [
      config.services.adguardhome.settings.dns.port
      67
    ];
  };

  services.adguardhome = {
    enable = true;
    mutableSettings = false;

    settings = {
      http.address = "127.0.0.1:3000";

      dns = {
        bind_hosts = [
          "127.0.0.1"
          hosts.home_srv
        ];
        port = 53;
        upstream_dns = [
          "tls://1.1.1.1"
          "quic://dns.quad9.net"
          "tls://dns.quad9.net"
        ];
        bootstrap_dns = [
          "tls://9.9.9.9"
          "tls://149.112.112.112"
          "tls://194.242.2.2"
        ];
        fallback_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
          "https://dns.mullvad.net/dns-query"
        ];
        upstream_mode = "load_balance";
        use_http3_upstreams = true;
        enable_dnssec = true;
        local_domain_name = "home.arpa";
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        blocking_mode = "default";
      };

      querylog.enabled = true;
      statistics.enabled = true;

      dhcp = {
        enabled = true;
        interface_name = "br0";

        dhcpv4 = {
          gateway_ip = hosts.router;
          inherit (lan) subnet_mask;
          inherit (lan.dhcp) range_start range_end;
          lease_duration = 86400;
          # LAN clients use AdGuard; the server has its own independent resolver.
          options = [ "6 ips ${hosts.home_srv}" ];
        };
      };
    };
  };
}
