{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Jellyfin media server
  services.jellyfin = {
    enable = true;
  };
}
