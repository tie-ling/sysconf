{ pkgs, lib, ... }: {
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
      # spell checkers
        hunspell
        # coma
        python3
        # used with dired mode to open files
        xdg-utils;
      inherit (pkgs.hunspellDicts) en_US de_DE;
    };
    interactiveShellInit = ''
      e () { $EDITOR --create-frame "$@"; }
    '';
    sessionVariables = {
      GDK_DPI_SCALE = lib.mkDefault "3";
      QT_FONT_DPI = lib.mkDefault (builtins.toString (3 * 96));
      VAAPI_DISABLE_INTERLACE = "1";
      W3M_DIR = "$HOME/.config/w3m";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "48";
      GNUPGHOME = "/old/home/yc/gpg";

    };
  };
}
