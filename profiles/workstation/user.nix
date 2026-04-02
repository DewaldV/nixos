{
  config,
  pkgs,
  ...
}:

{
  programs.zsh.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
