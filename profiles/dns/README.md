# Roaming DNS

`profiles.dns.roaming.enable` enables a NetworkManager/systemd-resolved policy
for laptops using secure Quad9 defaults. It is enabled on `dv-fw`.

Normal WiFi connections use Quad9 with required DNS-over-TLS and DNSSEC.
The Quad9 profile defaults both settings to enabled, independently.
Proton's tunnel keeps its own DNS servers and routing, with DNSSEC enabled and
DNS-over-TLS disabled. Other interfaces, including Tailscale, retain their own
per-link configuration.

## Captive portals

Disconnect Proton and disable any Proton kill switch, then connect to WiFi:

```sh
captive-portal on      # Use WiFi-supplied DNS without DoT or DNSSEC
captive-portal status  # Show portal mode and systemd-resolved's effective state
```

After signing in through the portal:

```sh
captive-portal off     # Restore Quad9, required DoT, and DNSSEC
```

Alternatively, run `captive-portal open`. This enables portal mode and launches
a separate Firefox instance at `http://neverssl.com`, using a disposable profile
with browser DoH and HTTPS-only mode disabled. Close that instance after signing
in. The command then polls `https://connectivitycheck.gstatic.com/generate_204`
over WiFi, requiring a valid HTTPS response with status 204. Once connectivity is
confirmed, it restores secure DNS. Failed probes retry every three seconds.

Cancelling the workflow or a browser failure also restores secure DNS. If the
WiFi session changes, the workflow stops without modifying the new connection.
Authentication may be requested again when restoring DNS.

The `on` and `off` commands request administrator authentication through
PolicyKit. Exactly one WiFi interface must be connected.

Portal mode is scoped to the current WiFi session, survives DHCP updates, and
ends on disconnect/reconnect or when Proton connects. Settings are runtime-only;
saved NetworkManager profiles are not modified. Resolver caches are flushed
after policy changes. The existing CrossCountry TCP-DNS workaround remains
necessary on that network.

The policy is also applied to connections already active when the configuration
is activated or systemd-resolved restarts.

The policy and browser workflow are Python scripts using only the standard
library, with shared command, locking, and WiFi-session helpers in `dns_common.py`.
Nix packages their interpreter and runtime commands (`nmcli`, `resolvectl`,
`curl`, and Firefox); no Python packages need to be installed separately.
