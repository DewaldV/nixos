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
    pkgs-unstable.signal-desktop

    # Productivity
    evince # PDF viewer
    gnome-calculator
    gnome-font-viewer
    libreoffice-fresh

    # Graphics & Media
    gimp
    imv

    # Security/VPN
    proton-vpn
    yubioath-flutter
  ];
}
