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
    host = "0.0.0.0";
  };
}
