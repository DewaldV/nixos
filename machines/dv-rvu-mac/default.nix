{ config, pkgs, ... }:

{
  imports = [ ../../profiles/nix/darwin.nix ];

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 6;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    coreutils-prefixed
    fontconfig
  ];

  fonts = {
    packages = with pkgs; [
      hack-font
      emacs-all-the-icons-fonts
      nerd-fonts.hack
      # symbola # currently unavailable
    ];
  };
}
