{
  # When creating zfs pools, use -o compatibility=zol-0.6.1
  # Use mountpoint=legacy for each and every dataset
  networking = {
    hostName = "tieling";
    hostId = "abcd1234";
  };
  time.timeZone = "Asia/Shanghai";

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

  fileSystems."/rtorrent" = {
    device = "rtorrent";
    fsType = "zfs";
    options = [ "X-mount.mkdir" "noatime" "nofail" ];
  };

  fileSystems."/home/our/新种子" = {
    device = "/rtorrent/watch";
    fsType = "none";
    options = [ "bind" "X-mount.mkdir" "nofail" ];
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
    options = [
      "x-systemd.idle-timeout=1min"
      "x-systemd.automount"
      "fmask=0077"
      "dmask=0077"
    ];
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
