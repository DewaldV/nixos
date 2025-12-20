{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  users.users.dewaldv.extraGroups = [ "docker" ];
}
