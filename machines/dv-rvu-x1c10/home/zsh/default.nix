{ config, pkgs, ... }:

{
  home.file.".zsh-custom/rust.zsh".source = ./zsh-custom/rust.zsh;
  home.file.".zsh-custom/rvu.zsh".source = ./zsh-custom/rvu.zsh;
  home.file.".zsh-custom/litellm.zsh".text = ''
    export LITE_LLM_API_KEY=$(cat ${config.age.secrets."rvu-litellm-personal-key".path});
  '';
}
