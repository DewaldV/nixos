{ config, ... }:

{
  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export WLR_RENDERER=vulkan;
    '';
  };

  home-manager.sharedModules = [ ./home.nix ];
}
