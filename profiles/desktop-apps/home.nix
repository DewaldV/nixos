{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ../proton-pass/desktop.nix
    ./foot.nix
  ];

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
    imv

    # Security/VPN
    protonvpn-gui
    yubioath-flutter
  ];
}
