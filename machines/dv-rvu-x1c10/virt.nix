{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;

  users.users.dewaldv.extraGroups = [ "libvirtd" "docker" ];
}
