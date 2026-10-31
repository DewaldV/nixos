{ ... }:
{
  imports = [
    ./vm-dl.nix
    ./vm-zeroclaw.nix
    ./vm-sync.nix
  ];

  age.secrets.beszel-agent-env = {
    owner = "microvm";
    group = "kvm";
  };

  networking.nftables.enable = true;
  virtualisation.libvirtd.firewallBackend = "nftables";
}
