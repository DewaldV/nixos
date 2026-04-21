{ pkgs, ... }:

let
  vmName = "dl-vm";
  mediaGroup = "media";
  mediaGid = 2000;
  vmMacAddress = "52:54:00:00:00:11";
  systemDiskPath = "/var/lib/libvirt/images/${vmName}.qcow2";
  systemDiskSize = "40G";
  dataSharePath = "/srv/${vmName}";
  ovmfCodePath = "${pkgs.OVMF.fd}/FV/OVMF_CODE.fd";
  ovmfVarsTemplatePath = pkgs.OVMF.variables;
  ovmfVarsPath = "/var/lib/libvirt/qemu/nvram/${vmName}_VARS.fd";
  domainXml = pkgs.writeText "${vmName}.xml" ''
    <domain type='kvm'>
      <name>${vmName}</name>
      <memory unit='MiB'>2048</memory>
      <vcpu placement='static'>1</vcpu>
      <os>
        <type arch='x86_64' machine='q35'>hvm</type>
        <loader readonly='yes' type='pflash'>${ovmfCodePath}</loader>
        <nvram template='${ovmfVarsTemplatePath}'>${ovmfVarsPath}</nvram>
      </os>
      <cpu mode='host-passthrough'/>
      <features>
        <acpi/>
        <apic/>
      </features>
      <clock offset='utc'/>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>restart</on_crash>
      <memoryBacking>
        <source type='memfd'/>
        <access mode='shared'/>
      </memoryBacking>
      <devices>
        <emulator>${pkgs.qemu}/bin/qemu-system-x86_64</emulator>
        <controller type='scsi' model='virtio-scsi'/>
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2' discard='unmap'/>
          <source file='${systemDiskPath}'/>
          <target dev='sda' bus='scsi'/>
        </disk>
        <interface type='bridge'>
          <mac address='${vmMacAddress}'/>
          <source bridge='br0'/>
          <model type='virtio'/>
        </interface>
        <filesystem type='mount' accessmode='passthrough'>
          <driver type='virtiofs'/>
          <source dir='${dataSharePath}'/>
          <target dir='dl-vm-data'/>
        </filesystem>
        <console type='pty'>
          <target type='serial' port='0'/>
        </console>
        <serial type='pty'>
          <target port='0'/>
        </serial>
        <rng model='virtio'>
          <backend model='random'>/dev/urandom</backend>
        </rng>
      </devices>
    </domain>
  '';
in
{
  users.groups.${mediaGroup}.gid = mediaGid;
  users.users.dewaldv.extraGroups = [ mediaGroup ];

  environment.systemPackages = with pkgs; [
    libvirt
    qemu
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/images 0755 root root - -"
    "d /var/lib/libvirt/qemu/nvram 0755 root root - -"
    "d ${dataSharePath} 2775 root ${mediaGroup} - -"
    "d ${dataSharePath}/incomplete 2775 root ${mediaGroup} - -"
    "d ${dataSharePath}/staging 2775 root ${mediaGroup} - -"
    "d ${dataSharePath}/complete 2775 root ${mediaGroup} - -"
  ];

  systemd.services."${vmName}-system-disk" = {
    description = "Create ${vmName} system disk";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -e "${systemDiskPath}" ]; then
        ${pkgs.qemu}/bin/qemu-img create -f qcow2 "${systemDiskPath}" ${systemDiskSize}
      fi
    '';
  };

  systemd.services."${vmName}-uefi-vars" = {
    description = "Create ${vmName} UEFI NVRAM";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -e "${ovmfVarsPath}" ]; then
        install -m 0644 "${ovmfVarsTemplatePath}" "${ovmfVarsPath}"
      fi
    '';
  };

  # systemd.services."libvirt-define-${vmName}" = {
  #   description = "Define ${vmName} libvirt domain";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [
  #     "libvirtd.service"
  #     "${vmName}-system-disk.service"
  #     "${vmName}-uefi-vars.service"
  #   ];
  #   wants = [
  #     "libvirtd.service"
  #     "${vmName}-system-disk.service"
  #     "${vmName}-uefi-vars.service"
  #   ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = ''
  #     ${pkgs.libvirt}/bin/virsh define ${domainXml}
  #   '';
  # };
}
