{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Development tool configurations
  imports = [
    ./direnv.nix
    ./git.nix
    ./rust
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    # Version control & CLI tools
    gh

    # AWS
    awscli2
    ssm-session-manager-plugin

    # Google Cloud
    google-cloud-sdk

    # Kubernetes
    helmfile
    k9s
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    kustomize

    # Development utilities
    devenv
    pre-commit

    # Shell dev
    shellcheck
    shfmt

    # Infrastructure as Code
    terraform
    tflint
    tflint-plugins.tflint-ruleset-aws

    # Languages
    python314
    ruby

    # k6
    pkgs-unstable.k6

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
    pnpm
  ];
}
