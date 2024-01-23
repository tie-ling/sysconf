{ config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    ../dot-config
    ../emacs
    ../environment/common.nix
    ../environment/desktop.nix
    ../networking/common.nix
    ../programs/common.nix
    ../programs/desktop.nix
    ../programs/home-manager.nix
    ../services/common.nix
    ../services/desktop.nix
    ../services/home-manager.nix
    ../tex-fontconfig
    ../users/common.nix
    ../users/yc.nix
    ../cn-mirror.nix
  ];
  boot.initrd.availableKernelModules = [ "i915" ];
  boot.initrd.systemd.enable = false;
  isoImage.squashfsCompression = "lz4";
}
