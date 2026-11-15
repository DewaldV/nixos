{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = with pkgs; [
    # AWS
    pkgs-unstable.awscli2
    ssm-session-manager-plugin

    # Azure
    azure-cli

    # Google Cloud
    gdk

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
