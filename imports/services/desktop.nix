{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          General = {
            GreeterEnvironment =
              "XCURSOR_SIZE=48,XCURSOR_THEME=Adwaita,XCURSOR_PATH=${pkgs.gnome.adwaita-icon-theme}/share/icons";
          };
        };
      };
    };
    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "suspend";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
    };
  };
}
