{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vagrant ];
  virtualisation.virtualbox.host.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;

  users.users.dewaldv = { extraGroups = [ "libvirtd" "vboxusers" "docker" ]; };
}
