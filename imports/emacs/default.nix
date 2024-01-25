{ pkgs, ... }: {
  home-manager.users.yc.xdg.configFile."emacs/init.el".source = ./init.el;
}
