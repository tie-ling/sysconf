{ config, pkgs, lib, inputs, modulesPath, ... }:
let
  inherit (lib) mkMerge mapAttrsToList mkDefault mkOption;
  inherit (inputs) self nixpkgs;
in {
  options = {
    services.i2pd.logLevel = mkOption {
      type = lib.types.enum [ "debug" "info" "warn" "error" "critical" "none" ];
    };
  };
  config = {
    services = {
      fwupd = { enable = true; };
      logrotate.checkConfig = false;
      dnscrypt-proxy2 = {
        enable = true;
        upstreamDefaults = true;
        settings = {
          ipv6_servers = true;
          listen_addresses = [ "127.0.0.1:53" "[::1]:53" ];
        };
      };
      resolved = { enable = true; };
      tlp = {
        enable = true;
        settings = {
          # defaults for lenovo ideapads
          # Stop charging battery BAT0 and BAT1 at 60%:
          # https://linrunner.de/tlp/settings/bc-vendors.html
          START_CHARGE_THRESH_BAT0 = mkDefault 0;
          STOP_CHARGE_THRESH_BAT0 = mkDefault 1;
        };
      };
      openssh = {
        enable = true;
        settings = { PasswordAuthentication = false; };
      };
      tor = {
        enable = mkDefault true;
        client = {
          enable = true;
          dns.enable = true;
        };
        settings = {
          Sandbox = true;
          SafeSocks = 1;
          NoExec = 1;
        };
        torsocks = {
          enable = true;
          server = "127.0.0.1:9050";
        };
      };
      i2pd = {
        enable = mkDefault true;
        enableIPv4 = true;
        enableIPv6 = true;
        bandwidth = 4096;
        logLevel = "none";
        port = 29392;
        proto = {
          http = {
            port = 7071;
            enable = true;
          };
          socksProxy.port = 4447;
          socksProxy.enable = true;
        };
        floodfill = true;
        inTunnels = { };
        outTunnels = {
          # connect to mail services by postman
          # available at http://hq.postman.i2p
          smtp-postman = {
            enable = true;
            address = "::1";
            destinationPort = 7659;
            destination = "smtp.postman.i2p";
            port = 7659;
          };
          pop-postman = {
            enable = true;
            address = "::1";
            destinationPort = 7660;
            destination = "pop.postman.i2p";
            port = 7660;
          };
        };
      };

      yggdrasil = {
        enable = true;
        openMulticastPort = false;
        extraArgs = [ "-loglevel" "error" ];
        settings.Peers =
          #curl -o test.html https://publicpeers.neilalexander.dev/
          # grep -e 'tls://' -e 'tcp://' -e 'quic://' test.html | grep online | sed 's|<td id="address">|"|' | sed 's|</td><td.*|"|g' | sort | wl-copy -n
          (import ./yggdrasil-peers.nix);
      };
    };
  };

}
