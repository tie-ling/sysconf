{

  imports = [ ../../imports/profiles/server.nix ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

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

  fileSystems."/var/lib" = {
    device = "/old/var/lib";
    fsType = "none";
    options = [ "bind" "X-mount.mkdir" "noatime" ];
  };

  fileSystems."/old" = {
    device = "npool/root";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "npool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-id/ata-WDC_WD20EJRX-89G3VY0_WD-WCC4M4SUXL4D-part1";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-id/ata-WDC_WD20EJRX-89G3VY0_WD-WCC4M4SUXL4D-part3";
      randomEncryption = true;
    }
    {
      device = "/dev/disk/by-id/ata-WDC_WD20EJRX-89G3VY0_WD-WCC4M6ZPTJ7X-part3";
      randomEncryption = true;
    }
  ];

}