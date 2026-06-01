{ ... }:

{
  profiles.machines.vm = {
    enable = true;
    address = "192.168.0.11";
  };

  fileSystems."/srv/data" = {
    device = "dl-vm-data";
    fsType = "virtiofs";
  };

  system.stateVersion = "25.11";
}
