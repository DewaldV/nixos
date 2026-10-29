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
    package = pkgs-unstable.immich;
    host = "0.0.0.0";
  };
}
