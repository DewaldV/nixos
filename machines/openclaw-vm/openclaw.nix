{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    pkgs-unstable.openclaw
  ];

  users.users.claw = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "docker" ];
  };
}
