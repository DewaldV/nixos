{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Immich photo management service
  services.immich = {
    enable = true;
  };
}
