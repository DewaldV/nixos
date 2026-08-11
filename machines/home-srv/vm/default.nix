{ ... }:
{
  imports = [
    ./dl-vm.nix
    ./vm-zeroclaw.nix
  ];

  networking.nftables.enable = true;
  virtualisation.libvirtd.firewallBackend = "nftables";
}
