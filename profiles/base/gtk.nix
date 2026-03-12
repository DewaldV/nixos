{
  config,
  lib,
  pkgs,
  ...
}:

{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };
  };

  # GTK4/libadwaita apps read color-scheme from dconf rather than gtk settings
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
