{
  config,
  lib,
  nixos-private,
  ...
}:

let
  vpn = nixos-private.private.vpn.dl-vm;
  interface = "protonvpn";
  lanCidr = "192.168.0.0/24";
  endpointParts = lib.splitString ":" vpn.peer.endpoint;
  endpointAddress = builtins.elemAt endpointParts 0;
  endpointPort = builtins.elemAt endpointParts 1;
in
{
  networking.wg-quick.interfaces.${interface} = {
    address = vpn.interface.address;
    dns = vpn.interface.dns;
    privateKeyFile = config.age.secrets.dl-vm-private-key.path;
    peers = [
      {
        inherit (vpn.peer)
          allowedIPs
          persistentKeepalive
          publicKey
          ;
        endpoint = vpn.peer.endpoint;
      }
    ];
  };

  networking.firewall = {
    checkReversePath = false;
    extraCommands = ''
      iptables -N vpn-egress 2>/dev/null || true
      iptables -F vpn-egress
      iptables -C OUTPUT -j vpn-egress 2>/dev/null || iptables -I OUTPUT 1 -j vpn-egress
      iptables -A vpn-egress -o lo -j RETURN
      iptables -A vpn-egress -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
      iptables -A vpn-egress -o ${interface} -j RETURN
      iptables -A vpn-egress -d ${lanCidr} -j RETURN
      iptables -A vpn-egress -p udp -d ${endpointAddress} --dport ${endpointPort} -j RETURN
      iptables -A vpn-egress -o eth0 -j REJECT

      ip6tables -N vpn-egress 2>/dev/null || true
      ip6tables -F vpn-egress
      ip6tables -C OUTPUT -j vpn-egress 2>/dev/null || ip6tables -I OUTPUT 1 -j vpn-egress
      ip6tables -A vpn-egress -o lo -j RETURN
      ip6tables -A vpn-egress -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
      ip6tables -A vpn-egress -o ${interface} -j RETURN
      ip6tables -A vpn-egress -o eth0 -j REJECT
    '';
    extraStopCommands = ''
      iptables -D OUTPUT -j vpn-egress 2>/dev/null || true
      iptables -F vpn-egress 2>/dev/null || true
      iptables -X vpn-egress 2>/dev/null || true

      ip6tables -D OUTPUT -j vpn-egress 2>/dev/null || true
      ip6tables -F vpn-egress 2>/dev/null || true
      ip6tables -X vpn-egress 2>/dev/null || true
    '';
  };
}
