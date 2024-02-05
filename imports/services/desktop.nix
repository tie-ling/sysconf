{ pkgs, ... }: {
  services = {
    emacs = {
      enable = true;
      package = ((pkgs.emacsPackagesFor pkgs.emacs29-nox).emacsWithPackages
        (epkgs:
          builtins.attrValues {
            inherit (epkgs.melpaPackages) nix-mode magit pyim pyim-basedict;
            inherit (epkgs.elpaPackages) auctex;
            inherit (epkgs.treesit-grammars) with-all-grammars;
          }));
      defaultEditor = true;
    };
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
