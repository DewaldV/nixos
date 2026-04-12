{ disko, ... }:

{
  imports = [
    disko.nixosModules.disko
    ../../profiles/sshd
    ./configuration.nix
    ./disko.nix
    ./hardware.nix
  ];
}
