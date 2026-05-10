{
  config,
  pkgs,
  ...
}:

{
  imports = [ ../user/dewaldv.nix ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  users.users.dewaldv.extraGroups = [
    "networkmanager"
    "video"
  ];
}
