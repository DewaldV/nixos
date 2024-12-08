{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users.dewaldv.extraGroups = [ "libvirtd" ];
}
