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
    pkgs-unstable.signal-desktop
    zoom-us

    # Productivity
    evince # PDF viewer
    gnome-calculator
    gnome-font-viewer
    libreoffice-fresh

    # Graphics & Media
    gimp

    # Security/VPN
    pkgs-unstable.proton-pass
    pkgs-unstable.proton-pass-cli
    protonvpn-gui
    yubioath-flutter
  ];
}
