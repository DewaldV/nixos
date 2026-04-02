{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."nix" = {
    allowDiscards = true;
    device = "/dev/disk/by-partlabel/nixos-crypt";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@var"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@snapshots"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/efi";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # AMD Radeon integrated graphics (4650GE Renoir/Cezanne)
  hardware.graphics.enable = true;
}
