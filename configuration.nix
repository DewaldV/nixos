{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "1";
  };
  boot.plymouth.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  networking.hostName = "dv-rvu-x1c10";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    earlySetup = true;
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "uk";
  };

  # Swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      _1password
      _1password-gui
      alacritty
      asdf-vm
      awscli2
      emacs-gtk
      fd
      firefox
      git
      gnome.gnome-tweaks
      hack-font
      htop
      jq
      k9s
      kubectl
      powertop
      ripgrep
      silver-searcher
      slack
      tmux
      xstow
    ];
  };

  # Programs
  programs.gnupg.agent.enable = true;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "\${HOME}/.zsh-custom";
      plugins = [ "aws" "git" "emacs" ];
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    curl
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
    gnumake
    nixfmt
    steampipe
    vim
    wget
  ];

  # Services
  services.xserver = {
    enable = true;

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    desktopManager.gnome.enable = true;

    layout = "gb";
    xkbVariant = "";
  };

  services.flatpak.enable = true;
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;

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
