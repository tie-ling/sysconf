{
  description = "Barebones NixOS on ZFS config";

  inputs = {
    # https://channels.nixos.org/nixpkgs-unstable/git-revision
    # https://channels.nixos.org/nixos-unstable/git-revision
    # using this one
    # https://channels.nixos.org/nixos-unstable-small/git-revision
    # https://channels.nixos.org/nixos-23.11-small/git-revision
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      mkHost = hostName: system:
        nixpkgs.lib.nixosSystem {
          pkgs = import nixpkgs {
            inherit system;
            nixpkgs.pkgs.zathura.useMupdf = true;
            overlays = [
              (final: prev: rec {
                zathura_core = prev.zathuraPkgs.zathura_core.overrideAttrs
                  (o: { patches = [ ./zathura-restart_syscall.patch ]; });
                zathura = prev.zathuraPkgs.zathuraWrapper.override {
                  inherit zathura_core;
                };
              })
            ];
          };
          specialArgs = { inherit inputs; };

          modules = [
            # Configuration per host
            ./hosts/${hostName}

            # home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
    in { nixosConfigurations = { qinghe = mkHost "qinghe" "x86_64-linux"; }; };
}
