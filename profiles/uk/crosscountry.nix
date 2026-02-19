{ pkgs, ... }:

{
  # CrossCountry only serves DNS on 53/tcp but systemd-resolved sends queries over
  # 53/udp first. Blocking outbound 53/udp forces resolution over TCP so we can
  # reach the captive portal to log in. Once the VPN is up, DNS runs over that instead.
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "crosscountry-dns-fix" ''
        if [ "$CONNECTION_ID" = "CrossCountryWiFi" ]; then
          case "$2" in
            up)
              ${pkgs.iptables}/bin/iptables -I OUTPUT -p udp --dport 53 -j DROP
              ;;
            down)
              ${pkgs.iptables}/bin/iptables -D OUTPUT -p udp --dport 53 -j DROP
              ;;
          esac
        fi
      '';
      type = "basic";
    }
  ];
}
