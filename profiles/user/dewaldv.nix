{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
