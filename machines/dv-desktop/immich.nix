{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  environment.systemPackages = [
    pkgs.immich-go
  ];

  services.immich = {
    enable = true;
  };
}
