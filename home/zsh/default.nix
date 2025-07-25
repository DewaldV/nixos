{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "\${HOME}/.zsh-custom";
      plugins = [
        "asdf"
        "aws"
        "azure"
        "emacs"
        "git"
        "rust"
      ];
    };
    shellAliases = {
      gc = "git commit -m";
      gbrclean = ''git branch --merged | egrep -v "^\*|  (master|main)" | xargs -r git branch -d'';
      tree = "tree -C";
      stree = "tree -aI .git";
    };
  };

  # home.file.".zsh-custom/asdf.zsh".text = ''
  #   export ASDF_DIR=${pkgs.asdf-vm}
  #   . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
  #   # append completions to fpath
  #   fpath=(''${ASDF_DIR}/completions $fpath)
  #   # initialise completions with ZSH's compinit
  #   autoload -Uz compinit && compinit
  # '';
  home.file.".zsh-custom/bin.zsh".source = ./zsh-custom/bin.zsh;
  home.file.".zsh-custom/go.zsh".source = ./zsh-custom/go.zsh;
  home.file.".zsh-custom/kube.zsh".source = ./zsh-custom/kube.zsh;
}
