{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  services.tailscale-systray = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };
}
