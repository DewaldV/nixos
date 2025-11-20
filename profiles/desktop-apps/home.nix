{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = with pkgs; [
    # Web browsers
    brave
    firefox

    # Communication
    discord
    pkgs-unstable.slack
    signal-desktop
    zoom-us

    # Productivity
    evince # PDF viewer
    gnome-calculator
    gnome-font-viewer
    libreoffice-fresh

    # Graphics & Media
    gimp

    # Security/VPN
    proton-pass
    protonvpn-gui
    yubioath-flutter
  ];
}
