{ modulesPath, disko, ... }:

{
  imports = [
    # Hardware-specific modules
    disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")

    # Profiles
    ../../profiles/dns/quad9.nix
    ../../profiles/nix
    ../../profiles/sshd
    ../../profiles/user/dewaldv.nix

    # Machine-specific config
    ./configuration.nix
    ./disko.nix
    ./hardware.nix
    ./transmission.nix
    ./vpn.nix
  ];
}
