{ config, pkgs, ... }:

{
  imports = [ ../../profiles/nix/darwin.nix ];

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 6;

  programs.zsh.enable = true;

  services.emacs = {
    enable = true;
    package = pkgs.emacs30;
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true; # fixes Touch ID for sudo inside tmux
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults = {
    NSGlobalDomain = {
      # Key repeat — lower values are faster
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;

      # Full keyboard UI control (tab through all UI controls, not just text fields)
      AppleKeyboardUIMode = 3;

      # Disable substitutions
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;

      # Metric units and 24-hour time
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleICUForce24HourTime = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
      orientation = "bottom";
      magnification = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf"; # search current folder by default
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };

  environment.systemPackages = with pkgs; [
    coreutils-prefixed
    fontconfig
  ];

  fonts = {
    packages = with pkgs; [
      hack-font
      emacs-all-the-icons-fonts
      nerd-fonts.hack
      # symbola # currently unavailable
    ];
  };
}
