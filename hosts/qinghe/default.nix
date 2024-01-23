{
  imports = [ ./configuration.nix ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/old/nix";
    fsType = "none";
    options = [ "bind" "X-mount.mkdir" "noatime" ];
  };

  fileSystems."/old" = {
    device =
      "/dev/mapper/luks-nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878-part2";
    fsType = "f2fs";
    neededForBoot = true;
  };

  boot.initrd.luks.devices."luks-nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878-part2" =
    {
      device =
        "/dev/disk/by-id/nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878-part2";
      allowDiscards = true;
      bypassWorkqueues = true;
    };

  fileSystems."/boot" = {
    device =
      "/dev/disk/by-id/nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878-part1";
    fsType = "vfat";
    options = [
      "x-systemd.idle-timeout=1min"
      "x-systemd.automount"
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [{
    device =
      "/dev/disk/by-id/nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878-part3";
    randomEncryption = true;
  }];

  hardware.cpu.intel.updateMicrocode = true;
}
