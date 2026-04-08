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

  # Grant jellyfin access to the GPU for VA-API hardware transcoding
  users.users.jellyfin.extraGroups = [
    "render" # access to /dev/dri/renderD128
    "video" # access to /dev/dri/card0
  ];
}
