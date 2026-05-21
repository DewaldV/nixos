{ ... }:
{
  imports = [
    ./dl-vm.nix
    ./openclaw-vm.nix
  ];

  networking.nftables.enable = true;
  virtualisation.libvirtd.firewallBackend = "nftables";
}
