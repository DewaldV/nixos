{ config, pkgs, ... }:

{
  # Virtualization with libvirt/KVM
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  # Add user to libvirtd group
  users.users.dewaldv.extraGroups = [ "libvirtd" ];
}
