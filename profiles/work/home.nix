{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version managers
    asdf-vm

    # Cloud providers
    aws-sam-cli
    azure-cli

    # Security & utilities
    snyk
    yq-go
  ];
}
