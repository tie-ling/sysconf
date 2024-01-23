{ pkgs, ... }:
let
  mytex = pkgs.texliveSmall.withPackages (ps:
    builtins.attrValues {
      inherit (ps)
        collection-basic collection-mathscience collection-pictures
        collection-luatex

        # languages
        collection-langenglish collection-langgerman

        # deal with intervals
        interval

        ####### fonts
        # otf fonts
        xcharter xcharter-math
        #######

        ###### pdf manipulation tool
        pdfjam # depends on pdfpages, geometry
        # pdfpages and dependencies
        pdfpages eso-pic atbegshi pdflscape
        ######

        ###### misc
        # unicode-math and deps
        unicode-math fontspec realscripts lualatex-math
        # quotes
        csquotes
        # checks
        chktex lacheck;
    });

  ycFontsConf =
    pkgs.writeText "fc-56-yc-fonts.conf" (builtins.readFile ./fontconfig.xml);
  confPkg = pkgs.runCommand "fontconfig-conf" { preferLocalBuild = true; } ''
    dst=$out/etc/fonts/conf.d
    mkdir -p $dst

    # 56-yc-fonts.conf
    ln -s ${ycFontsConf} $dst/56-yc-fonts.conf
  '';
in {
  security.apparmor.includes."abstractions/fonts" = ''
    # 56-yc-fonts.conf
     r ${ycFontsConf},
  '';

  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JuliaMono" "DejaVu Sans Mono" "Noto Sans Mono CJK SC" ];
      sansSerif = [ "XCharter" "Noto Serif" "Noto Sans CJK SC" ];
      serif = [ "XCharter" "Noto Serif" "Noto Sans CJK SC" ];
    };
    confPackages = [ confPkg ];
  };
  fonts.packages = builtins.attrValues {
    inherit (pkgs)
      noto-fonts dejavu_fonts noto-fonts-cjk-sans julia-mono inconsolata-lgc;
  } ++ [ mytex.fonts ];

  environment.systemPackages = [ mytex ];
}
