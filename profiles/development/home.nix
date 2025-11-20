{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version control & CLI tools
    # Note: git is in base/home.nix
    gh

    # Cloud & Kubernetes
    argocd
    awscli2
    google-cloud-sdk
    helmfile
    k9s
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    ssm-session-manager-plugin

    # Development utilities
    pre-commit
    shellcheck
    shfmt

    # Infrastructure as Code
    terraform
    tflint
    tflint-plugins.tflint-ruleset-aws

    # Languages
    python311

    # Go development tools
    dockfmt
    errcheck
    gci
    go
    gocode-gomod
    golangci-lint
    golangci-lint-langserver
    gomodifytags
    gopls
    gore
    gotests
    gotestsum
    gotools
    go-tools
    unconvert

    # Node.js
    bun
    nodejs_24
  ];
}
