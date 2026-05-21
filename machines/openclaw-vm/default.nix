{ modulesPath, disko, ... }:

{
  imports = [
    # Hardware-specific modules
    disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")

    # Profiles
    ../../profiles/server
    ../../profiles/docker

    # Machine-specific config
    ./configuration.nix
    ./disko.nix
    ./hardware.nix
    ./openclaw.nix
  ];
}
