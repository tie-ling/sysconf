{ ... }: {
  imports = [ ../../imports/profiles/desktop.nix ];
  networking = {
    hostName = "qinghe";
    hostId = "abcd1234";
  };
  time.timeZone = "Europe/Berlin";
  environment.sessionVariables = {
    QT_FONT_DPI = builtins.toString (2 * 96);
    GDK_DPI_SCALE = "2";
  };
  home-manager.users.yc = {
    wayland.windowManager.sway.config = {
      input."9580:109:GAOMON_Gaomon_Tablet_Pen"."map_to_region" =
        "1152 648 1408 792";
      output = let to2k = { mode = "--custom 2560x1440@60Hz"; };
      in {
        "DP-3" = to2k;
        "DP-4" = to2k;
        "DP-5" = to2k;
      };
    };
  };
}
