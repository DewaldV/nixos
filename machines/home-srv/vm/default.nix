{ ... }:
{
  imports = [
    ./vm-dl.nix
    ./vm-zeroclaw.nix
  ];

  networking.nftables.enable = true;
  virtualisation.libvirtd.firewallBackend = "nftables";
}
