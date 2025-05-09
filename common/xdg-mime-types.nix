{ pkgs, config, ... }:

let
  browser = [
    "brave-browser.desktop" # assume brave provides this
  ];
  associations = {
    "inode/directory" = [ "thunar.desktop" ];
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
  };
in
{
  xdg.mime.enable = true;
  xdg.mime.addedAssociations = associations;
  xdg.mime.defaultApplications = associations;
}
