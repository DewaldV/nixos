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

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      _1password
      _1password-gui
      alacritty
      asdf-vm
      awscli2
      firefox
      go
      k9s
      kubectl
      kubernetes-helm
      ruby_3_1
      slack
      ssm-session-manager-plugin
      terraform
      tflint
      tflint-plugins.tflint-ruleset-aws
      xstow
    ];
  };
}
