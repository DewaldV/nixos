{ pkgs, ... }:

{
  # Headless KVM/libvirt host with the default libvirt NAT network.
  virtualisation.libvirtd = {
    enable = true;
  };

  users.users.dewaldv.extraGroups = [ "libvirtd" ];
}
