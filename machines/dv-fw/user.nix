{ config, pkgs, home-manager, ... }:

{
  users.users.dewaldv.packages = with pkgs; [ godot_4 ];
}
