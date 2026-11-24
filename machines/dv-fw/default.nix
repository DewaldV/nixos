{
  config,
  pkgs,
  nixos-hardware,
  ...
}:
{
  imports = [
    # Hardware-specific module
    nixos-hardware.nixosModules.framework-13-7040-amd

    # Profiles
    ../../profiles/workstation
    ../../profiles/sway
    ../../profiles/desktop-apps
    ../../profiles/gaming
    ../../profiles/laptop
    ../../profiles/uk/crosscountry.nix

    # Machine-specific config
    ./configuration.nix
    ./hardware.nix
    ./fanctrl.nix
  ];
}
