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
    ../../profiles/server
    ../../profiles/caddy
    ../../profiles/jellyfin
    ../../profiles/immich

    # Machine-specific config
    ./configuration.nix
    ./hardware.nix
  ];
}
