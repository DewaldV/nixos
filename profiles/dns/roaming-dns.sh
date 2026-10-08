# Runtime-only resolver policy. Never change saved NetworkManager profiles.
fail() { printf '%s\n' "$*" >&2; exit 1; }
action=${1:-status}
state=/run/captive-portal

if [[ "$action" == status ]]; then
  enabled=false
  if [[ -d "$state" ]]; then
    for marker in "$state"/*; do
      [[ -f "$marker" ]] || continue
      printf 'Captive-portal mode enabled on %s\n' "${marker##*/}"
      enabled=true
    done
  fi
  "$enabled" || printf 'Captive-portal mode disabled.\n'
  resolvectl status
  exit 0
fi
[[ $EUID == 0 ]] || fail 'DNS policy changes require root.'
install -d -m 755 "$state"
exec 9> /run/roaming-dns.lock
flock 9

secure_wifi() {
  resolvectl dnsovertls "$iface" yes
  resolvectl dnssec "$iface" yes
  resolvectl dns "$iface" 9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net \
    2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
  # No catch-all domain: Proton's ~. must take precedence over WiFi.
  resolvectl domain "$iface" ""
  resolvectl default-route "$iface" yes
}

portal_wifi() {
  local servers=() server
  while IFS= read -r server; do
    [[ -n "$server" ]] && servers+=("$server")
  done < <(nmcli --escape no -g IP4.DNS,IP6.DNS device show "$iface")
  ((${#servers[@]})) || fail "No network-provided DNS servers on $iface."
  resolvectl dnsovertls "$iface" no
  resolvectl dnssec "$iface" no
  resolvectl dns "$iface" "${servers[@]}"
  # Prefer the local resolver over globally configured Quad9 for portal names.
  resolvectl domain "$iface" '~.'
  resolvectl default-route "$iface" yes
}

case "$action" in
  on|off)
    interfaces=()
    while IFS=: read -r device type connection_state; do
      if [[ "$type" == wifi && "$connection_state" == connected ]]; then
        interfaces+=("$device")
      fi
    done < <(LC_ALL=C nmcli -t -f DEVICE,TYPE,STATE device status)
    ((${#interfaces[@]} == 1)) || fail 'Expected exactly one connected WiFi interface.'
    iface=${interfaces[0]}
    uuid=$(nmcli -g GENERAL.CON-UUID device show "$iface")
    # The browser workflow must never change a different WiFi session.
    [[ -z "${2:-}" || "$2" == "$uuid" ]] || fail 'The WiFi session changed; DNS policy was not modified.'
    if [[ "$action" == on ]]; then
      if nmcli -t -f NAME,DEVICE connection show --active | \
          grep -Eq '(^ProtonVPN |:proton[0-9]+$|^pvpn-killswitch)'; then
        fail 'Disconnect Proton and disable its kill switch before enabling captive-portal mode.'
      fi
      portal_wifi
      printf '%s\n' "$uuid" > "$state/$iface"
      printf 'Captive-portal mode enabled on %s. Restore with: captive-portal off\n' "$iface"
    else
      secure_wifi
      rm -f "$state/$iface"
      printf 'Secure DNS restored on %s.\n' "$iface"
    fi
    ;;
  event)
    iface=${2:?Missing interface}
    event=${3:?Missing event}
    [[ "$iface" =~ ^[a-zA-Z0-9_.:-]+$ && "$iface" != . && "$iface" != .. ]] || fail 'Invalid interface.'
    case "$event" in
      down|vpn-down)
        rm -f "$state/$iface"
        resolvectl flush-caches
        exit 0
        ;;
      up|vpn-up) rm -f "$state/$iface" ;;
      dhcp4-change|dhcp6-change|reapply) ;;
      *) exit 0 ;;
    esac
    if [[ "$iface" =~ ^proton[0-9]+$ || "${CONNECTION_ID:-}" == ProtonVPN\ * ]]; then
      resolvectl dnsovertls "$iface" no
      resolvectl dnssec "$iface" yes
      # End portal mode when Proton starts so two ~. links cannot share queries.
      proton_iface=$iface
      for marker in "$state"/*; do
        [[ -f "$marker" ]] || continue
        iface=${marker##*/}
        if [[ $(nmcli -g GENERAL.STATE device show "$iface") == 100* ]]; then
          secure_wifi
        fi
        rm -f "$marker"
      done
      iface=$proton_iface
    elif [[ $(nmcli -g GENERAL.TYPE device show "$iface") == wifi ]]; then
      uuid=$(nmcli -g GENERAL.CON-UUID device show "$iface")
      if [[ -f "$state/$iface" && $(< "$state/$iface") == "$uuid" ]]; then
        portal_wifi
      else
        rm -f "$state/$iface"
        secure_wifi
      fi
    else
      exit 0
    fi
    ;;
  *) fail 'Usage: captive-portal [on|off|status]' ;;
esac
resolvectl flush-caches
