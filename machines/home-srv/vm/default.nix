{ ... }:
{
  imports = [
    ./dl-vm.nix
    ./openclaw-vm.nix
    ./vm-zeroclaw.nix
  ];

  networking.nftables.enable = true;
  virtualisation.libvirtd.firewallBackend = "nftables";
}
