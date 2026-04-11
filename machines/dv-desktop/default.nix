{
  config,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    # Hardware-specific modules
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd

    # Profiles
    ../../profiles/workstation
    ../../profiles/desktop-apps
    ../../profiles/gaming
    ../../profiles/sshd
    ../../profiles/virtualization
    ../../profiles/llm
    # Note: development and desktop-apps profiles are home-manager only (no system config)

    # Machine-specific config
    ./configuration.nix
    ./hardware.nix
  ];
}
