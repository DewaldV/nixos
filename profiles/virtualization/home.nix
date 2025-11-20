{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Virt-manager connection settings
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
