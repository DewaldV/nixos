{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    netrc-file = "/etc/nix/netrc";
  };

  nixpkgs.config.allowUnfree = true;

  # Boot
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_6_18;
    kernelParams = [ "quiet" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    plymouth.enable = true;
  };

  networking.networkmanager.enable = true;
  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::92"
  ];

  networking.wireguard.enable = true;

  # Timezone and Locale
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  # User configuration
  security.polkit.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  fonts = {
    enableDefaultPackages = true;
    packages =
      with pkgs;
      [
        fira
        fira-mono
        font-awesome
        hack-font
        hackgen-nf-font
        material-design-icons
        noto-fonts
        roboto
        unifont
        weather-icons
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig.enable = true;
    fontDir.enable = true;
  };

  # Programs
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "dewaldv" ];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # System-level packages only
  # Note: User-facing utilities moved to profiles/base/home.nix
  # Note: GUI apps moved to profiles/desktop-apps
  # Note: Development tools moved to profiles/development
  environment.systemPackages = with pkgs; [
    # Build tools
    gcc
    gnumake

    # System utilities (require root/system integration)
    e2fsprogs
    glib
    gparted
    nvd
    parted
    pciutils
    polkit_gnome
    tpm2-tss
    usbutils
    wireguard-tools
    xdg-utils
  ];

  # Services
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;

  services.resolved = {
    enable = true;
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::92"
    ];
    dnssec = "true";
    extraConfig = ''
      [Resolve]
      DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
      DNSOverTLS=yes
    '';
  };

  # Gnome Keyring
  security.pam.services.dewaldv.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable sound.
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
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
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

    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.Screencast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
    };
  };

  security.pam.services.swaylock = { };

  virtualisation.podman.enable = true;

  # Show diff before activation
  system.activationScripts.preActivation = ''
    if [[ -e /run/current-system ]]; then
      echo "--- diff to current-system"
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      echo "---"
    fi
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
