{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.fuzzel = {

    enable = true;
    settings = {
      colors = {
        background = "1a1a1add";
        text = "d1d1d1ff";
        match = "f38ba8ff";
        selection = "585858ff";
        selection-match = "f38ba8ff";
        selection-text = "cdd6f4ff";
        border = "b4b4b4ff";
      };
    };
  };
}
