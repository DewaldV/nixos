{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      icons = true;
      defaultTimeout = 5000;
      font = "Noto Sans 10";
      borderRadius = 4;
      # catppuccin/mako: https://github.com/catppuccin/mako/blob/main/src/mocha
      backgroundColor = "#1e1e2e";
      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "over #313244";
      "urgency=high" = {
        border-color = "#fab387";
      };
    };
  };
}
