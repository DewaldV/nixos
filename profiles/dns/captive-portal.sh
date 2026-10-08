change_mode() {
  /run/wrappers/bin/pkexec "$dns_policy" "$@"
}

case "${1:-status}" in
  status) exec "$dns_policy" status ;;
  on|off) change_mode "$@"; exit ;;
  open) ;;
  *) printf 'Usage: captive-portal [on|off|open|status]\n' >&2; exit 1 ;;
esac

# Prevent concurrent browser workflows in the same login session.
exec 8> "${XDG_RUNTIME_DIR:?Missing XDG_RUNTIME_DIR}/captive-portal-open.lock"
if ! flock -n 8; then
  printf 'A captive-portal browser workflow is already running.\n' >&2
  exit 1
fi

interfaces=()
while IFS=: read -r device type connection_state; do
  if [[ "$type" == wifi && "$connection_state" == connected ]]; then
    interfaces+=("$device")
  fi
done < <(LC_ALL=C nmcli -t -f DEVICE,TYPE,STATE device status)
if ((${#interfaces[@]} != 1)); then
  printf 'Expected exactly one connected WiFi interface.\n' >&2
  exit 1
fi
iface=${interfaces[0]}
uuid=$(nmcli -g GENERAL.CON-UUID device show "$iface")

same_session() {
  [[ $(nmcli -g GENERAL.CON-UUID device show "$iface" 2>/dev/null) == "$uuid" ]]
}

profile=$(mktemp -d -t captive-portal-firefox.XXXXXXXX)
portal_enabled=false
browser_pid=
# Invoked indirectly by the EXIT trap below.
# shellcheck disable=SC2329
cleanup() {
  local result=$?
  trap - EXIT
  if [[ -n "$browser_pid" ]]; then
    kill "$browser_pid" 2>/dev/null || true
    wait "$browser_pid" 2>/dev/null || true
  fi
  rm -rf "$profile"
  if "$portal_enabled" && same_session; then
    printf 'Restoring secure DNS before exiting.\n'
    change_mode off "$uuid" || result=1
  fi
  exit "$result"
}
trap 'cleanup' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Use the system resolver and allow the HTTP page to reach a portal redirect.
cat > "$profile/user.js" <<'PREFS'
user_pref("network.trr.mode", 5);
user_pref("dom.security.https_only_mode", false);
user_pref("dom.security.https_only_mode_pbm", false);
user_pref("dom.security.https_first", false);
user_pref("dom.security.https_first_pbm", false);
user_pref("network.captive-portal-service.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.dataSubmissionEnabled", false);
PREFS

change_mode on "$uuid"
portal_enabled=true
printf 'Sign in through the portal, then close this Firefox instance.\n'
firefox --no-remote --new-instance --profile "$profile" http://neverssl.com &
browser_pid=$!
wait "$browser_pid"
browser_pid=

printf 'Browser closed. Waiting for Internet connectivity (Ctrl+C to cancel).\n'
while same_session; do
  # Require a valid HTTPS response and the expected status, not a portal redirect.
  # Bind the probe to WiFi so another interface cannot produce a false success.
  if code=$(curl --silent --show-error --noproxy '*' --interface "$iface" \
      --connect-timeout 5 --max-time 10 --output /dev/null --write-out '%{http_code}' \
      https://connectivitycheck.gstatic.com/generate_204) && [[ "$code" == 204 ]]; then
    change_mode off "$uuid"
    portal_enabled=false
    printf 'Internet connectivity confirmed; secure DNS restored.\n'
    exit 0
  fi
  printf 'Not online yet; retrying in 3 seconds.\n'
  sleep 3
done

# Disconnect/reconnect already resets portal mode through the dispatcher.
portal_enabled=false
printf 'WiFi session changed; stopping the captive-portal workflow.\n' >&2
exit 1
