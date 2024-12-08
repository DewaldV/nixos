{
  config,
  lib,
  pkgs,
  pkgs-unstable,
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
    device = "/dev/disk/by-uuid/13bb5138-5e02-46ed-bfea-6f8b73a32ac4";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/005c89d0-4848-4509-88ae-78f45bc692e7";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
      "discard=async"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/077B-142B";
    fsType = "vfat";
  };

  boot.initrd.luks.devices."games" = {
    allowDiscards = true;
    device = "/dev/disk/by-partlabel/games-crypt";
  };

  fileSystems."/home/dewaldv/Games2" = {
    device = "/dev/disk/by-label/games";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
      "discard=async"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  hardware.bluetooth.enable = true;

  # amdvlk seems to have lower performance than mesa radv
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
  # https://nixos.org/manual/nixos/unstable/index.html#sec-gpu-accel-vulkan
  # https://nixos.wiki/wiki/AMD_GPU
  # https://www.phoronix.com/review/amdvlk-radv-rx7900
  hardware.graphics = {
    enable = true;

    # package = pkgs-unstable.mesa.drivers;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    # extraPackages = [ pkgs-unstable.amdvlk ];
    # extraPackages32 = [ pkgs-unstable.driversi686Linux.amdvlk ];
  };

  hardware.amdgpu.amdvlk.enable = false;
}
