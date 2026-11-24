{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  google-cloud-sdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
    ]
  );
in
{
  imports = [
    ./doom
    ./identity.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    # AWS
    pkgs-unstable.awscli2
    ssm-session-manager-plugin

    # Azure
    azure-cli

    # Google Cloud
    google-cloud-sdk

    # Kubernetes
    helmfile
    k9s
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    kustomize

    # Node.js
    bun
    nodejs_24
    pnpm

    # Security & utilities
    snyk
    yq-go
  ];
}
