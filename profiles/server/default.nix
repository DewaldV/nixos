{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Disable desktop-only services that are enabled in profiles/base
  services.greetd.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;
  services.flatpak.enable = lib.mkForce false;
  services.printing.enable = lib.mkForce false;
  services.tumbler.enable = lib.mkForce false;
  services.gvfs.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
  programs.seahorse.enable = lib.mkForce false;
  programs._1password.enable = lib.mkForce false;
  programs._1password-gui.enable = lib.mkForce false;
  programs.thunar.enable = lib.mkForce false;
  programs.dconf.enable = lib.mkForce false;
  xdg.portal.enable = lib.mkForce false;
  security.pam.services.greetd = lib.mkForce { };
  security.pam.services.swaylock = lib.mkForce { };
  boot.plymouth.enable = lib.mkForce false;

  # Disable desktop-only systemd user services
  systemd.user.services.polkit-gnome-authentication-agent-1 = lib.mkForce { };

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
