{ config, ... }: {
  users.users = {
    yc = {
      # "!" means login disabled
      initialHashedPassword =
        "$6$UxT9KYGGV6ik$BhH3Q.2F8x1llZQLUS1Gm4AxU7bmgZUP7pNX6Qt3qrdXUy7ZYByl5RVyKKMp/DuHZgk.RiiEXK8YVH.b2nuOO/";
      description = "Yuchen Guo";
      # a default group must be set
      extraGroups = [
        # use doas
        "wheel"
        # manage VMs
        "libvirtd"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWeAeIuIf2Zyv+d+J6ZWGuKx1lmKFa6UtzCTNtB5+Ev openpgp:0x1FD7B98A"
      ];
      isNormalUser = true;
      uid = 1000;
    };
  };
  home-manager.users.yc.accounts.email = {
    maildirBasePath = "/old/home/yc/Mail";

    accounts = {
      "gmail" = {
        primary = true;
        address = "gyuchen86@gmail.com";
        flavor = "gmail.com";
        mu.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          remove = "both";
          patterns = [ "INBOX" ];
          groups = {
            gmail-group = {
              channels = {
                # https://apple.stackexchange.com/a/201346
                inbox = {
                  extraConfig.Create = "Near";
                  farPattern = "INBOX";
                  nearPattern = "Inbox";
                };
                sent = {
                  extraConfig.Create = "Near";
                  farPattern = "[Gmail]/Sent Mail";
                  nearPattern = "Sent";
                };
                trash = {
                  extraConfig.Create = "Near";
                  farPattern = "[Gmail]/Trash";
                  nearPattern = "Trash";
                };
                drafts = {
                  extraConfig.Create = "Near";
                  farPattern = "[Gmail]/Drafts";
                  nearPattern = "Drafts";
                };
                archive = {
                  extraConfig.Create = "Near";
                  farPattern = "[Gmail]/Starred";
                  nearPattern = "Archive";
                };
                flagged = {
                  extraConfig.Create = "Near";
                  farPattern = "[Gmail]/Important";
                  nearPattern = "Flagged";
                };
                junk = {
                  extraConfig.Create = "Near";
                  farPattern = "[Gmail]/Spam";
                  nearPattern = "Junk";
                };
              };
            };
          };
        };
        msmtp.enable = true;
        passwordCommand =
          "PASSWORD_STORE_DIR=/old/home/yc/passwd pass show email/gmail-app-password";
        realName = "Yuchen Guo";
      };
    };
  };
  home-manager.users.yc.home = {
    username = "yc";
    homeDirectory = "/home/yc";
    stateVersion = config.system.stateVersion;
  };

}
