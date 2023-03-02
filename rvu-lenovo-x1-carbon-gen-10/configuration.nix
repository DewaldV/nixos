# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/x1/10th-gen>
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  networking.hostName = "dv-rvu-x1c10"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.flatpak.enable = true;
  
  services.fprintd = {
    enable = true;
#    tod = {
#      enable = true;
#      driver = "";
#    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dewaldv = {
    isNormalUser = true;
    description = "Dewald Viljoen";
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;

    packages = with pkgs; [
      firefox
      emacs-gtk
      git
      slack
      _1password
      _1password-gui
      hack-font
      gnome.gnome-tweaks
      alacritty
      htop
      silver-searcher
      ripgrep
      fd
      xstow
      jq
      kubectl
      awscli2
      k9s
      tmux
      powertop
      gnomeExtensions.vitals
    ];
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "\${HOME}/.zsh-custom";
      plugins = [ "aws" "git" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     curl
     vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.xserver = {
    enable = true;

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    desktopManager = {
      gnome.enable = true;
    };

    layout = "gb";
    xkbVariant = "";
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.fwupd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
