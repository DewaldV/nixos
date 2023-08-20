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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      argocd
      alacritty
      asdf-vm
      awscli2
      firefox
      go
      gopls
      gocode-gomod
      gotools
      gore
      gotests
      gotestsum
      gomodifytags
      google-cloud-sdk
      kind
      minikube
      pre-commit
      k9s
      kubectl
      kubernetes-helm
      ruby_3_1
      skypeforlinux
      slack
      ssm-session-manager-plugin
      tflint
      tflint-plugins.tflint-ruleset-aws
      xstow
      zoom-us
    ];
  };
}
