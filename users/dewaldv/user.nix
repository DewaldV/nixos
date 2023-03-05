{ config, pkgs, home-manager, ... }:

{
  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      _1password
      _1password-gui
      alacritty
      asdf-vm
      awscli2
      emacs-gtk
      firefox
      hack-font
      k9s
      kubectl
      slack
      xstow
    ];
  };
}
