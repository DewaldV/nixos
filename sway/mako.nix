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
      default-timeout = 5000;
      font = "Noto Sans 10";
      border-radius = 4;
      # catppuccin/mako: https://github.com/catppuccin/mako/blob/main/src/mocha
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #313244";
      "urgency=high" = {
        border-color = "#fab387";
      };
      on-button-middle = "exec makoctl menu -n \"$id\" fuzzel -- -d -p 'Action:'";
    };
  };
}
