{ config, pkgs, ... }: {
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = (if config.programs.sway.enable then "qt" else "tty");
    enableSSHSupport = true;
  };
  # sway and related sound config
  hardware.opengl.extraPackages =
    builtins.attrValues { inherit (pkgs) vaapiIntel intel-media-driver; };
  hardware.pulseaudio.enable = false;
  sound.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  programs.sway = {
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    enable = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        swaylock swayidle foot wl-gammactl brightnessctl fuzzel grim libva-utils
        w3m gsettings-desktop-schemas pavucontrol waybar wl-clipboard
        wf-recorder;
    };
    # must be enabled, or else many programs will crash
    wrapperFeatures.gtk = true;
  };
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    policies = {
      "ExtensionSettings" = {
        "uMatrix@raymondhill.net" = {
          "installation_mode" = "normal_installed";
          "install_url" = ("file://" + ../../umatrix-1.4.4.xpi);
          "default_area" = "navbar";
        };
      };
      "3rdparty" = {
        Extensions = {
          # name must be the same as above
          "uBlock0@raymondhill.net" = {
            adminSettings = {
              userSettings = {
                advancedUserEnabled = true;
                popupPanelSections = 31;
              };
              dynamicFilteringString = ''
                * * inline-script block
                * * 1p-script block
                * * 3p-script block
                * * 3p-frame block'';
              hostnameSwitchesString = ''
                no-cosmetic-filtering: * true
                no-remote-fonts: * true
                no-csp-reports: * true
                no-scripting: * true
              '';
            };
          };
        };
      };
      # captive portal enabled for connecting to free wifi
      CaptivePortal = false;
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
      };
      DisableBuiltinPDFViewer = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayMenuBar = "never";
      DNSOverHTTPS = { Enabled = false; };
      DontCheckDefaultBrowser = true;
      EncryptedMediaExtensions = { Enabled = false; };
      ExtensionUpdate = false;
      FirefoxHome = {
        SponsoredTopSites = false;
        Pocket = false;
        SponsoredPocket = false;
      };
      HardwareAcceleration = true;
      Homepage = { StartPage = "none"; };
      NetworkPrediction = false;
      NewTabPage = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      PDFjs = { Enabled = false; };
      Permissions = {
        Location = { BlockNewRequests = true; };
        Notifications = { BlockNewRequests = true; };
      };
      PictureInPicture = { Enabled = false; };
      PopupBlocking = { Default = false; };
      PromptForDownloadLocation = true;
      SearchSuggestEnabled = false;
      ShowHomeButton = true;
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
      };

    };
    preferences = {
      "browser.aboutConfig.showWarning" = false;
      "browser.backspace_action" = 0;
      "browser.chrome.site_icons" = false;
      "browser.display.use_document_fonts" = 0;
      "browser.tabs.firefox-view" = false;
      "browser.tabs.inTitlebar" = 0;
      "browser.uidensity" = 1;
      "general.smoothScroll" = false;
      "gfx.font_rendering.opentype_svg.enabled" = false;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.navigator.mediadatadecoder_vpx_enabled" = true;
      "network.IDN_show_punycode" = true;
      "dom.security.https_only_mode" = true;
    };
    preferencesStatus = "default";
    autoConfig = ''
      pref("apz.allow_double_tap_zooming", false);
      pref("apz.allow_zooming", false);
      pref("apz.gtk.touchpad_pinch.enabled", false);
      pref("webgl.disable-extensions", true);
      pref("webgl.disable-fail-if-major-performance-caveat", true);
      pref("webgl.disabled", true);
      pref("webgl.min_capability_mode", true);
      pref("javascript.enabled", false);
      pref("javascript.options.asmjs", false);
      pref("javascript.options.wasm", false);
      pref("javascript.options.ion", false);
      pref("javascript.options.baselinejit", false);
      pref("font.name-list.emoji", "Noto Color Emoji");
    '';
  };
}
