{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "\${HOME}/.zsh-custom";
      plugins = [ "asdf" "aws" "emacs" "git" ];
    };
    shellAliases = {
      gc = "git commit -m";
      gbrclean =
        "git branch --merged | egrep -v '(^*|master|main)' | xargs git branch -d";
      tree = "tree -C";
      stree = "tree -aI .git";
    };
  };

  home.file.".zsh-custom/kube.zsh".source = ./zsh-custom/kube.zsh;
}
