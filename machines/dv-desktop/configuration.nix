{ config, pkgs, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

in {
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";

  console = { keyMap = "us"; };

  services.xserver.layout = "us";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty # gpu accelerated terminal
    bemenu # wayland clone of dmenu
    configure-gtk
    dbus-sway-environment
    dracula-theme # gtk theme
    glib # gsettings
    gnome3.adwaita-icon-theme # default gnome cursors
    grim # screenshot functionality
    mako # notification system developed by swaywm maintainer
    slurp # screenshot functionality
    sway
    swayidle
    swaylock
    wayland
    wdisplays # tool to configure displays
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    xdg-utils # for opening default programs when clicking links
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
