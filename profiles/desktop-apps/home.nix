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
    # Note: signal-desktop is in base/home.nix
    discord
    pkgs-unstable.slack
    zoom-us

    # Productivity
    evince # PDF viewer
    gnome-calculator
    gnome-font-viewer
    libreoffice-fresh

    # Graphics & Media
    flameshot
    gimp
    helvum
  ];
}
