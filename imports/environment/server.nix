{ pkgs, ... }: {
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        smartmontools darkhttpd pyrosimple woeusb _7zz exfatprogs;
    };
    loginShellInit = ''
      dsrv () {
        darkhttpd . --addr ::1 --ipv6 --port 8088
      }
      Nb () {
        if test -z "$TMUX"; then
           echo 'not in tmux';
           return 1
        fi
        nixos-rebuild boot \
         --flake git+file:///home/yc/git/sysconf
      }
      Ns () {
        if test -z "$TMUX"; then
           echo 'not in tmux';
           return 1
        fi
        nixos-rebuild switch \
         --flake git+file:///home/yc/git/sysconf
      }
      tm () {
         tmux attach-session
      }
      e () {
        ${pkgs.emacs-nox}/bin/emacsclient --create-frame --alternate-editor= $@
      }
    '';
  };
}
