{ ... }:

{
  imports = [ ./ghostty.nix ];

  programs.aerospace = {
    enable = true;
    launchd.enable = true;
  };
}
