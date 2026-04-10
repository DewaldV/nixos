{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "client";
  };
}
