{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };

  # Use loose reverse path filtering to allow Tailscale's direct peer-to-peer connections.
  # Strict mode (default) blocks packets from overlay networks where the source IP doesn't
  # match the expected routing table entry for that interface. Loose mode still validates
  # that a route exists to the source IP, preventing completely spoofed packets while
  # allowing mesh networks, VPNs, and containers to function properly.
  networking.firewall.checkReversePath = "loose";
}
