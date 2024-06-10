{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vagrant ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users.dewaldv.extraGroups = [ "libvirtd" ];
}
