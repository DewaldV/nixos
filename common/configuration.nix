{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.netrc-file = "/etc/nix/netrc";
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_6_7;
    kernelParams = [ "quiet" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    plymouth.enable = true;
  };

  networking.networkmanager.enable = true;
  networking.nameservers =
    [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

  networking.wireguard.enable = true;

  # Timezone and Locale
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  security.polkit.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      emacs-all-the-icons-fonts
      fira
      fira-mono
      font-awesome
      hack-font
      hackgen-nf-font
      material-design-icons
      nerdfonts
      noto-fonts
      roboto
      unifont
      weather-icons
    ];
    fontconfig.enable = true;
    fontDir.enable = true;
  };

  # Programs
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryFlavor = "gnome3";
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "dewaldv" ];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btop
    curl
    dig
    discord
    distrobox
    evince # pdf document viewer
    fd
    file
    firefox
    gcc
    gh
    gimp
    git
    glib
    gnome.gnome-calculator
    gnome.gnome-font-viewer
    gnumake
    gparted
    grim
    helmfile
    htop
    insync
    ipcalc
    ispell
    jq
    kanshi
    lsof
    neofetch
    nixfmt
    nixos-artwork.wallpapers.dracula
    parted
    pavucontrol
    pciutils
    podman
    polkit_gnome
    powertop
    protonvpn-cli
    protonvpn-gui
    pulseaudio
    python311
    ripgrep
    s-tui
    signal-desktop
    silver-searcher
    skypeforlinux
    slack
    stow
    stress
    sway-contrib.grimshot
    swaylock
    terraform
    tpm2-tss
    tree
    unzip
    usbutils
    vim
    wget
    wl-clipboard
    wofi
    wofi-emoji
    xdg-utils
    yubioath-flutter
    zoom-us
  ];

  # Services
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs.emacs29-pgtk;
  };

  services.resolved = {
    enable = true;
    fallbackDns =
      [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  services.tailscale.enable = true;

  # Gnome Keyring
  security.pam.services.dewaldv.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  systemd = {
    user = {
      extraConfig = ''
        DefaultEnvironment="PATH=/run/current-system/sw/bin"
      '';

      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # warning: xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
    # should either set `xdg.portal.config` or `xdg.portal.configPackages`
    # to specify which portal backend to use for the requested interface.

    # https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in

    # If you simply want to keep the behaviour in < 1.17, which uses the first
    # portal implementation found in lexicographical order, use the following:

    # xdg.portal.config.common.default = "*";
    config.common.default = "*";
  };

  security.pam.services.swaylock = { };

  virtualisation.podman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
