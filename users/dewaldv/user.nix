{ config, pkgs, home-manager, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "\${HOME}/.zsh-custom";
      plugins = [ "aws" "git" "emacs" ];
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
      kind
      minikube
      k9s
      kubectl
      kubernetes-helm
      ruby_3_1
      slack
      ssm-session-manager-plugin
      tflint
      tflint-plugins.tflint-ruleset-aws
      xstow
    ];
  };
}
