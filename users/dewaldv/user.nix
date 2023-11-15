{ config, pkgs, home-manager, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "\${HOME}/.zsh-custom";
      plugins = [ "asdf" "aws" "emacs" "git" ];
    };
  };

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      argocd
      asdf-vm
      awscli2
      editorconfig-core-c
      go
      gocode-gomod
      gomodifytags
      google-cloud-sdk
      gopls
      gore
      gotests
      gotestsum
      gotools
      k9s
      kubectl
      kubernetes-helm
      kubernetes-helmPlugins.helm-diff
      libreoffice-fresh
      pandoc
      pre-commit
      ruby_3_1
      cargo
      rustc
      shellcheck
      shfmt
      ssm-session-manager-plugin
      tflint
      tflint-plugins.tflint-ruleset-aws
      xstow
    ];
  };
}
