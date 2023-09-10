{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.netrc-file = "/etc/nix/netrc";
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_6_4;
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
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      fira-mono
      font-awesome
      hack-font
      noto-fonts
      roboto
    ];
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

  programs.thunar.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btop
    chromium
    curl
    dig
    discord
    distrobox
    evince # pdf document viewer
    fd
    gcc
    gh
    gimp
    git
    gnome.gnome-calculator
    gnumake
    gparted
    grim
    helmfile
    htop
    insync
    ipcalc
    jq
    kanshi
    neofetch
    nixfmt
    nixos-artwork.wallpapers.dracula
    parted
    pavucontrol
    pciutils
    podman
    powertop
    protonvpn-cli
    protonvpn-gui
    python311
    ripgrep
    s-tui
    signal-desktop
    silver-searcher
    stow
    stress
    sway-contrib.grimshot
    swaylock
    terraform
    tmux
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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.pam.services.swaylock = { };

  virtualisation = { podman = { enable = true; }; };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
