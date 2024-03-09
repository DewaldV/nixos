{ config, pkgs, home-manager, ... }:

{

  programs.zsh.enable = true;

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "docker" "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      argocd
      asdf-vm
      awscli2
      editorconfig-core-c
      flameshot
      go
      gocode-gomod
      gomodifytags
      google-cloud-sdk
      gopls
      gore
      gotests
      gotestsum
      gotools
      gzdoom
      helvum
      k9s
      kubectl
      kubernetes-helm
      kubernetes-helmPlugins.helm-diff
      libreoffice-fresh
      pandoc
      pre-commit
      ruby_3_1
      shellcheck
      shfmt
      ssm-session-manager-plugin
      tflint
      tflint-plugins.tflint-ruleset-aws
      xstow
    ];
  };
}
