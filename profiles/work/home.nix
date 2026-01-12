{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version managers
    asdf-vm

    # Cloud providers
    azure-cli

    # Security & utilities
    snyk
    yq-go
  ];
}
