{ pkgs, lib, ... }: {

  # rtorrent related 

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 1048576;
    "fs.file-max" = 65536;
  };
  # clean up watch dir after one day
  systemd.services.rtorrent.serviceConfig.LimitNOFILE = 10240;

  services = {
    zfs = {
      autoScrub = {
        enable = true;
        interval = "quarterly";
      };
    };
    # nfs4 does not need rpcbind
    services.rpcbind.enable = lib.mkForce false;
    nfs = {
      # kodi/coreelec uses nfs3 by default
      # switch to nfs4 by using settings here
      # https://kodi.wiki/view/Settings/Services/NFS_Client

      # NO ENCRYPTION, CLEAR TEXT!
      # use for only public shares or tunnel through something like ssh
      server = {
        enable = true;
        createMountPoints = true;
        extraNfsdConfig = ''
          vers3=no
          vers4=yes
        '';
        exports = ''
          /rtorrent    192.168.1.0/24(ro,all_squash)
        '';
      };
    };
    samba-wsdd.enable = false;
    samba = {
      enable = true;
      openFirewall = true;
      # add user password with
      # printf 'woxiangshuoqinaidemaizi\nwoxiangshuoqinaidemaizi' | smbpasswd -s -a our
      # saves to /var/lib/samba

      # 用windows电脑建立连接：此电脑->映射网络驱动器->输入
      # \\192.168.1.192\bt，勾选“使用其他凭据”，输入用户名our和密码。
      # 必须直接输入ip地址来建立连接，基于安全原因，自动探索模式和访客
      # 已被禁用。
      enableNmbd = false;
      enableWinbindd = false;
      extraConfig = ''
        map to guest = Never
        server smb encrypt = required
        server min protocol = SMB3
      '';
      shares = {
        our = {
          path = "/home/our";
          "read only" = false;
          "hosts allow" = "192.168.1.";
        };
        bt = {
          path = "/rtorrent/已下载";
          "read only" = true;
          "hosts allow" = "192.168.1.";
        };
      };
    };
    rtorrent = {
      enable = true;
      dataDir = "/rtorrent/dataDir";
      downloadDir = "/rtorrent/已下载";
      openFirewall = true;
      port = 50000;
      dataPermissions = "0755";
      configText = ''
        # pyroadmin config --create-rtorrent-rc
        # rtorrent program settings
        system.umask.set = 0022

        # torrent network settings
        dht.mode.set = on
        protocol.pex.set = yes
        trackers.use_udp.set = yes
        protocol.encryption.set = none

        # watch dir
        # created and permission set by systemd tmpdir rules
        method.insert = cfg.watchDir1, private|const|string, "/rtorrent/watch"
        # Watch directories (add more as you like, but use unique schedule names)
        schedule2 = watch_start, 10, 10, ((load.start, (cat, (cfg.watchDir1), "/*.torrent")))

        # xmlrpc
        network.xmlrpc.size_limit.set = 8M
      '';
    };
    openssh = {
      ports = [ 22 65222 ];
      allowSFTP = true;
      openFirewall = true;
    };
    yggdrasil.persistentKeys = true;
    tor = {
      enable = true;
      relay = {
        enable = false;
        onionServices = {
          ssh = {
            authorizedClients = [ ];
            map = [{
              port = 22;
              target = {
                addr = "[::1]";
                port = 22;
              };
            }];
          };
        };
      };
      settings = {
        ClientUseIPv6 = true;
        ClientPreferIPv6ORPort = true;
        ClientUseIPv4 = true;
        UseBridges = 0;
        Bridge = [ ];
      };
    };
    i2pd = {
      enable = true;
      inTunnels = {
        ssh-server = {
          enable = true;
          address = "::1";
          destination = "::1";
          port = 65222;
          accessList = [ ]; # to lazy to only allow zfs-root laptops
        };
      };
    };
  };
}
