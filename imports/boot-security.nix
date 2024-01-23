{ modulesPath, inputs, lib, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot = {
    initrd = {
      systemd.enable = true;
      systemd.emergencyAccess =
        "$6$UxT9KYGGV6ik$BhH3Q.2F8x1llZQLUS1Gm4AxU7bmgZUP7pNX6Qt3qrdXUy7ZYByl5RVyKKMp/DuHZgk.RiiEXK8YVH.b2nuOO/";
    };
  };
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/hardened.nix")
  ];

  boot.blacklistedKernelModules = lib.mkForce [];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  zramSwap.enable = true;

  console.useXkbConfig = true;

  security = {
    doas.enable = true;
    sudo.enable = false;
    lockKernelModules = false;
  };
}
