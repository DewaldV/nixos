{
  lib,
  ...
}:

{
  services.resolved = {
    enable = true;
    extraConfig = lib.mkAfter ''
      [Resolve]
      DNSStubListener=no
    '';
  };

  networking.nameservers = [ "127.0.0.1" ];

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [
      53
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
          "192.168.0.10"
        ];
        port = 53;
        upstream_dns = [
          "quic://dns.quad9.net"
          "https://dns.quad9.net/dns-query"
          "https://dns.mullvad.net/dns-query"
        ];
        bootstrap_dns = [
          "tls://9.9.9.9"
          "tls://149.112.112.112"
          "tls://194.242.2.2"
        ];
        fallback_dns = [
          "tls://dns.quad9.net"
          "https://dns.cloudflare.com/dns-query"
          "tls://1.1.1.1"
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
          gateway_ip = "192.168.0.1";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.0.100";
          range_end = "192.168.0.200";
          lease_duration = 86400;
        };
      };
    };
  };
}
