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
    ../../profiles/gaming
    ../../profiles/laptop
    # Note: development and desktop-apps profiles are home-manager only (no system config)

    # Machine-specific config
    ./configuration.nix
    ./hardware.nix
    ./fanctrl.nix
  ];
}
