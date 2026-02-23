{
  config,
  nixos-private,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dv-desktop";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
      8096 # Jellyfin
      2283 # Immich API
    ];
    allowedUDPPorts = [
      41641 # Tailscale
    ];
  };

  console.keyMap = "us";

  services.xserver.xkb.layout = "us";
  services.blueman.enable = true;
  services.ratbagd.enable = true;

  services.power-profiles-daemon.enable = true;

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Allow SSH access with personal key
  users.users.dewaldv.openssh.authorizedKeys.keys = [
    nixos-private.private.keys.personal.ssh.pub
  ];

  # Suppress USB audio control errors during device initialisation.
  # The Schiit Fulla stalls on GET_CUR requests at boot causing ALSA mixer
  # attach failures (EPIPE/Broken pipe), which prevents WirePlumber from
  # saving and restoring volume state for the device.
  boot.extraModprobeConfig = ''
    options snd_usb_audio ignore_ctl_error=1
  '';

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    piper
    system76-keyboard-configurator
  ];
}
