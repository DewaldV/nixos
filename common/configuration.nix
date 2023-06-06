{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.netrc-file = "/etc/nix/netrc";
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.kernelPackages = pkgs.linuxPackages_6_3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.plymouth.enable = true;

  networking.networkmanager.enable = true;
  networking.nameservers =
    [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

  # Timezone and Locale
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

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
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "dewaldv" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    pavucontrol
    xdg-utils
    btop
    chromium
    curl
    dig
    fd
    gcc
    gimp
    git
    gnumake
    htop
    ipcalc
    # insync-v3
    jq
    nixfmt
    podman
    powertop
    python311
    ripgrep
    silver-searcher
    tmux
    tree
    unzip
    vim
    wget
    yubioath-flutter
  ];

  # Services
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  services.resolved = {
    enable = true;
    fallbackDns =
      [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
