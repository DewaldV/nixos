{ pkgs, ... }:

let
  vmName = "openclaw-vm";
  networkName = vmName;
  bridgeName = "virbr-openclaw";
  networkGateway = "10.50.0.1";
  dhcpRangeStart = "10.50.0.100";
  dhcpRangeEnd = "10.50.0.200";
  vmMacAddress = "52:54:00:00:00:12";
  systemDiskPath = "/var/lib/libvirt/images/${vmName}.qcow2";
  systemDiskSize = "40G";
  ovmfCodePath = "${pkgs.OVMF.fd}/FV/OVMF_CODE.fd";
  ovmfVarsTemplatePath = "${pkgs.OVMF.fd}/FV/OVMF_VARS.fd";
  ovmfVarsPath = "/var/lib/libvirt/qemu/nvram/${vmName}_VARS.fd";
  networkXml = pkgs.writeText "${networkName}.xml" ''
    <network>
      <name>${networkName}</name>
      <forward mode='nat'/>
      <bridge name='${bridgeName}' stp='on' delay='0'/>
      <ip address='${networkGateway}' netmask='255.255.255.0'>
        <dhcp>
          <range start='${dhcpRangeStart}' end='${dhcpRangeEnd}'/>
        </dhcp>
      </ip>
    </network>
  '';
  domainXml = pkgs.writeText "${vmName}.xml" ''
    <domain type='kvm'>
      <name>${vmName}</name>
      <memory unit='MiB'>4096</memory>
      <vcpu placement='static'>2</vcpu>
      <metadata>
        <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
          <libosinfo:os id="http://nixos.org/nixos/25.11"/>
        </libosinfo:libosinfo>
      </metadata>
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
      <devices>
        <emulator>${pkgs.qemu}/bin/qemu-system-x86_64</emulator>
        <controller type='scsi' model='virtio-scsi'/>
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2' discard='unmap'/>
          <source file='${systemDiskPath}'/>
          <target dev='sda' bus='scsi'/>
        </disk>
        <interface type='network'>
          <mac address='${vmMacAddress}'/>
          <source network='${networkName}'/>
          <model type='virtio'/>
        </interface>
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
  environment.systemPackages = with pkgs; [
    libvirt
    qemu
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/images 0755 root root - -"
    "d /var/lib/libvirt/qemu/nvram 0755 root root - -"
  ];

  networking.firewall.extraForwardRules = ''
    iifname "${bridgeName}" ip daddr 192.168.0.0/24 reject
  '';

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
    description = "Create ${vmName} UEFI variable store";
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

  systemd.services."libvirt-network-${networkName}" = {
    description = "Define and start ${networkName} libvirt network";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    wants = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.libvirt}/bin/virsh net-define ${networkXml}
      ${pkgs.libvirt}/bin/virsh net-autostart ${networkName}
      if ! ${pkgs.libvirt}/bin/virsh net-info ${networkName} | grep -q '^Active:.*yes'; then
        ${pkgs.libvirt}/bin/virsh net-start ${networkName}
      fi
    '';
  };

  systemd.services."libvirt-define-${vmName}" = {
    description = "Define ${vmName} libvirt domain";
    wantedBy = [ "multi-user.target" ];
    after = [
      "libvirtd.service"
      "libvirt-network-${networkName}.service"
      "${vmName}-system-disk.service"
      "${vmName}-uefi-vars.service"
    ];
    wants = [
      "libvirtd.service"
      "libvirt-network-${networkName}.service"
      "${vmName}-system-disk.service"
      "${vmName}-uefi-vars.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.libvirt}/bin/virsh define ${domainXml}
    '';
  };
}
