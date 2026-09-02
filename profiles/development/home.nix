{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in
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
    pkgs-unstable.awscli2
    ssm-session-manager-plugin

    # Google Cloud
    gdk

    # Kubernetes
    helmfile
    k9s
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    kustomize

    # Development utilities
    pkgs-unstable.devenv

    # Shell dev
    shellcheck
    shfmt

    # Infrastructure as Code
    terraform
    tflint
    tflint-plugins.tflint-ruleset-aws

    # Languages
    python314
    uv
    # ruby

    # k6
    pkgs-unstable.k6

    # Go development tools
    dockfmt
    errcheck
    gci
    pkgs-unstable.go
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
