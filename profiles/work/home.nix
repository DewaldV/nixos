{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Cloud providers
    azure-cli

    # Security & utilities
    snyk
    yq-go
  ];
}
