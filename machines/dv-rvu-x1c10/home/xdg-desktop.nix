{ config, pkgs, ... }: {
  xdg.desktopEntries.firefoxPersonal = {
    categories = [ "Network" "WebBrowser" ];
    exec = "firefox --name firefox -P Personal";
    genericName = "Web Browser";
    icon = "firefox";
    name = "Firefox (Personal)";
    startupNotify = true;
    terminal = false;
    type = "Application";
  };
}
