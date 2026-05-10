{ config, pkgs, ... }:

{
  # Virtualization with libvirt/KVM
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  };

  # Add user to libvirtd group
  users.users.dewaldv.extraGroups = [ "libvirtd" ];
}
