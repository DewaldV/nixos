{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    github-cli
    pkgs-unstable.codex
    pkgs-unstable.opencode
    pkgs-unstable.openclaw
  ];

  users.users.claw = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "docker" ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      18789 # Openclaw Gateway
    ];
  };
}
