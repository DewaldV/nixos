{ config, pkgs, ... }:

let
  emacsPackage = pkgs.emacs30-pgtk;
in
{
  home.file.".doom.d/config.el".source = ./doom.d/config.el;
  home.file.".doom.d/init.el".source = ./doom.d/init.el;
  home.file.".doom.d/packages.el".source = ./doom.d/packages.el;
  home.file.".doom.d/modules".source = ./doom.d/modules;
  home.file.".doom.d/personal".source = ./doom.d/personal;

  home.packages = with pkgs; [
    # Doom Emacs requisites
    fd
    git
    findutils
    ripgrep

    # all-the-icons-fonts
    emacs-all-the-icons-fonts

    # Go dev tools
    dockfmt
    errcheck
    gci
    go
    gocode-gomod
    golangci-lint
    golangci-lint-langserver
    gomodifytags
    gopls
    gore
    gotests
    gotestsum
    gotools
    go-tools
    unconvert
  ];

  # For these programs to work correctly on Ubuntu Gnome it is required to add
  # the XDG_DATA_DIRS and PATH values that Nix normally adds to the shell to
  # /etc/environment or /etc/environment.d/50-nix.conf
  #
  # This is because the gnome-shell process runs as a SystemD user unit and
  # therefore does not get environment variables set via /etc/profile.d/nix.sh
  #
  # Need some investigation to determine a better way to manage these env vars.
  programs.emacs = {

    enable = true;
    package = emacsPackage;
  };

  services.emacs = {
    enable = true;

    defaultEditor = true;
    startWithUserSession = true;

    client.enable = true;
  };

  # This desktop entry is overwritten to solve an issue with Gnome icon pinning.
  #
  # Gnome Wayland matches the desktop file name to the app_id to track an app's windows.
  # The default desktop file from the package launches emacs directly, this
  # overrides that to launch emacsclient instead.
  xdg.desktopEntries = {
    emacs = {
      categories = [
        "Development"
        "TextEditor"
      ];
      comment = "Edit Text";
      exec = "${emacsPackage}/bin/emacsclient -c %F";
      genericName = "Text Editor";
      icon = "emacs";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      name = "Emacs";
      terminal = false;
      type = "Application";
    };
  };
}
