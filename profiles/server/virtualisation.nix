{ pkgs, ... }:

{
  # Headless KVM/libvirt host with the default libvirt NAT network.
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  };

  users.users.dewaldv.extraGroups = [ "libvirtd" ];
}
