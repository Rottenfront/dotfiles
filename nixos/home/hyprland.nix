{
  lib,
  config,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland:xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct:qt6ct";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    PROTON_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    playerctl
    brightnessctl
    hyprpolkitagent
    hyprpaper

    quickshell
    cava
    lm_sensors
    wf-recorder
    libnotify
    pipewire
    wl-clipboard
    python3
    gawk
    gnused
    procps
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ ];
  };

  services.hyprpolkitagent.enable = true;

  systemd.user.services.cliphist.Service = {
    ExecStart = lib.mkForce "${lib.getExe' config.services.cliphist.clipboardPackage "wl-paste"} --type text --watch ${lib.getExe config.services.cliphist.package} ${lib.escapeShellArgs config.services.cliphist.extraOptions} store";
    UMask = "0077";
  };
  systemd.user.services.cliphist-images.Service.UMask = "0077";

  xdg.configFile = {
    "xkb/symbols/en_custom".text = ''
      // Colemak symbols for xkb on X.Org Server 7.x
      // 2006-01-01 Shai Coleman, http://colemak.com/

      partial alphanumeric_keys
      xkb_symbols "colemak" {
          name[Group1]= "Colemak";
          key <TLDE> { [        grave,   asciitilde,      dead_tilde,       asciitilde ] };
          key <AE01> { [            1,       exclam,      exclamdown,      onesuperior ] };
          key <AE02> { [            2,           at,       masculine,      twosuperior ] };
          key <AE03> { [            3,   numbersign,     ordfeminine,    threesuperior ] };
          key <AE04> { [            4,       dollar,            cent,         sterling ] };
          key <AE05> { [            5,      percent,        EuroSign,              yen ] };
          key <AE06> { [            6,  asciicircum,         hstroke,          Hstroke ] };
          key <AE07> { [            7,    ampersand,             eth,              ETH ] };
          key <AE08> { [            8,     asterisk,           thorn,            THORN ] };
          key <AE09> { [            9,    parenleft,  leftsinglequotemark,  leftdoublequotemark ] };
          key <AE10> { [            0,   parenright, rightsinglequotemark,  rightdoublequotemark ] };
          key <AE11> { [        minus,   underscore,          endash,           emdash ] };
          key <AE12> { [        equal,         plus,        multiply,         division ] };

          key <AD01> { [            q,            Q,      adiaeresis,       Adiaeresis ] };
          key <AD02> { [            w,            W,           aring,            Aring ] };
          key <AD03> { [            f,            F,          atilde,           Atilde ] };
          key <AD04> { [            p,            P,          oslash,           Oslash ] };
          key <AD05> { [            g,            G,     dead_ogonek,       asciitilde ] };
          key <AD06> { [            j,            J,         dstroke,          Dstroke ] };
          key <AD07> { [            l,            L,         lstroke,          Lstroke ] };
          key <AD08> { [            u,            U,          uacute,           Uacute ] };
          key <AD09> { [            y,            Y,      udiaeresis,       Udiaeresis ] };
          key <AD10> { [    semicolon,        colon,      odiaeresis,       Odiaeresis ] };
          key <AD11> { [  bracketleft,    braceleft,   guillemotleft,        0x1002039 ] };
          key <AD12> { [ bracketright,   braceright,  guillemotright,        0x100203a ] };
          key <BKSL> { [    backslash,          bar,      asciitilde,       asciitilde ] };

          key <AC01> { [            a,            A,          aacute,           Aacute ] };
          key <AC02> { [            r,            R,      dead_grave,       asciitilde ] };
          key <AC03> { [            s,            S,          ssharp,        0x1001e9e ] };
          key <AC04> { [            t,            T,      dead_acute, dead_doubleacute ] };
          key <AC05> { [            d,            D,  dead_diaeresis,       asciitilde ] };
          key <AC06> { [            h,            H,      dead_caron,       asciitilde ] };
          key <AC07> { [            n,            N,          ntilde,           Ntilde ] };
          key <AC08> { [            e,            E,          eacute,           Eacute ] };
          key <AC09> { [            i,            I,          iacute,           Iacute ] };
          key <AC10> { [            o,            O,          oacute,           Oacute ] };
          key <AC11> { [   apostrophe,     quotedbl,          otilde,           Otilde ] };

          key <AB01> { [            z,            Z,              ae,               AE ] };
          key <AB02> { [            x,            X, dead_circumflex,       asciitilde ] };
          key <AB03> { [            c,            C,        ccedilla,         Ccedilla ] };
          key <AB04> { [            v,            V,              oe,               OE ] };
          key <AB05> { [            b,            B,      dead_breve,       asciitilde ] };
          key <AB06> { [            k,            K,  dead_abovering,       asciitilde ] };
          key <AB07> { [            m,            M,     dead_macron,       asciitilde ] };
          key <AB08> { [        comma,         less, dead_belowcomma,       asciitilde ] };
          key <AB09> { [       period,      greater,   dead_abovedot,       asciitilde ] };
          key <AB10> { [        slash,     question,    questiondown,       asciitilde ] };

          key <LSGT> { [        minus,   underscore,          endash,           emdash ] };
          key <SPCE> { [        space,        space,           space,     nobreakspace ] };

          key <RALT> {[  ISO_Level3_Shift  ], type[group1]="ONE_LEVEL" };
      };


    '';

    "xkb/symbols/ru_custom".text = ''
      // Rulemak, Colemak based Russian phonetic layout
      // contact: Geert Hendrickx <geert@hendrickx.be>
      // https://forum.colemak.com/viewtopic.php?id=519
      //
      // ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┲━━━━━━━━━┓
      // │ Ё ◌̏ │ ! ◌̋ │ " ² │ № ³ │ ; £ │ % ¥ │ : ◌̄ │ ?   │ * ₴ │ ( { │ ) } │ _ — │ + ÷ ┃ ⌫       ┃
      // │ ё ◌̀ │ 1 ◌́ │ 2 ◌̈ │ 3 # │ 4 $ │ 5 € │ 6 ◌̆ │ 7 & │ 8 ₽ │ 9 [ │ 0 ] │ - – │ = × ┃Backspace┃
      // ┢━━━━━┷━┱───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┺━┳━━━━━━━┫
      // ┃       ┃ Я Ѣ │ Ж Ѵ │ Ф Ѳ │ П   │ Г Ґ │ й Ј │ Л Љ │ У Ў │ Ы Ї │ Ю : │ Ш „ │ Щ “ ┃ Enter ┃
      // ┃ Tab ↹ ┃ я ѣ │ ж ѵ │ ф ѳ │ п   │ г ґ │ й ј │ л љ │ у ў │ ы ї │ ю ; │ ш « │ щ » ┃   ⏎   ┃
      // ┣━━━━━━━┻┱────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┺┓      ┃
      // ┃ ⌫ Back ┃ А ʼ │ Р   │ С   │ Т Ћ │ Д Ђ │ Ч Џ │ Н Њ │ Е Є │ И І │ О   │ Ь Ъ │ Э ” ┃      ┃
      // ┃  space ┃ а ' │ р ® │ с @ │ т ћ │ д ђ │ ч џ │ н њ │ е є │ и і │ о   │ ь ъ │ э ’ ┃      ┃
      // ┣━━━━━━━━┻━┱───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┲━━━┷━━━━━┻━━━━━━┫
      // ┃          ┃ З Ѕ │ Х   │ Ц   │ В   │ Б Ѓ │ К Ќ │ М   │ ;   │ :   │ ? | ┃                ┃
      // ┃  Shift ⇧ ┃ з ѕ │ х   │ ц © │ в   │ б ѓ │ к ќ │ м   │ , < │ . > │ / \ ┃     Shift ⇧    ┃
      // ┣━━━━━━━┳━━┻━━━━┳┷━━━━━┷┱────┴─────┴─────┴─────┴─────┴─────┴┲━━━━┷━━┳━━┻━━━━┳━━━━━━━┳━━━┛
      // ┃       ┃       ┃       ┃                                   ┃       ┃       ┃       ┃
      // ┃ Ctrl  ┃ Meta  ┃  Alt  ┃                Space              ┃AltGr ⇮┃ Menu  ┃ Ctrl  ┃
      // ┗━━━━━━━┻━━━━━━━┻━━━━━━━┹───────────────────────────────────┺━━━━━━━┻━━━━━━━┻━━━━━━━┛

      partial alphanumeric_keys
      xkb_symbols "rulemak" {
          name[Group1]= "Russian (Rulemak)";

          key <TLDE> { [     Cyrillic_io,     Cyrillic_IO,           U0300,           U030F ] }; // Combining grave, double grave
          key <AE01> { [               1,          exclam,           U0301,           U030B ] }; // Combining acute, double acute
          key <AE02> { [               2,        quotedbl,           U0308,     twosuperior ] }; // Combining diaeresis
          key <AE03> { [               3,      numerosign,      numbersign,   threesuperior ] };
          key <AE04> { [               4,       semicolon,          dollar,        sterling ] };
          key <AE05> { [               5,         percent,        EuroSign,             yen ] };
          key <AE06> { [               6,           colon,           U0306,           U0304 ] }; // Combining breve, macron
          key <AE07> { [               7,        question,       ampersand                  ] };
          key <AE08> { [               8,        asterisk,           U20BD,           U20B4 ] }; // ruble, hryvnia
          key <AE09> { [               9,       parenleft,     bracketleft,       braceleft ] };
          key <AE10> { [               0,      parenright,    bracketright,      braceright ] };
          key <AE11> { [           minus,      underscore,          endash,          emdash ] };
          key <AE12> { [           equal,            plus,        multiply,        division ] };

          key <AD01> { [     Cyrillic_ya,     Cyrillic_YA,           U0463,           U0462 ] }; // yat
          key <AD02> { [    Cyrillic_zhe,    Cyrillic_ZHE,           U0475,           U0474 ] }; // izhitsa
          key <AD03> { [     Cyrillic_ef,     Cyrillic_EF,           U0473,           U0472 ] }; // fita
          key <AD04> { [     Cyrillic_pe,     Cyrillic_PE                                   ] };
          key <AD05> { [    Cyrillic_ghe,    Cyrillic_GHE, Ukrainian_ghe_with_upturn, Ukrainian_GHE_WITH_UPTURN ] };
          key <AD06> { [ Cyrillic_shorti, Cyrillic_SHORTI,     Cyrillic_je,     Cyrillic_JE ] };
          key <AD07> { [     Cyrillic_el,     Cyrillic_EL,    Cyrillic_lje,    Cyrillic_LJE ] };
          key <AD08> { [      Cyrillic_u,      Cyrillic_U, Byelorussian_shortu, Byelorussian_SHORTU ] };
          key <AD09> { [   Cyrillic_yeru,   Cyrillic_YERU,    Ukrainian_yi,    Ukrainian_YI ] };
          key <AD10> { [     Cyrillic_yu,     Cyrillic_YU,       semicolon,           colon ] };
          key <AD11> { [    Cyrillic_sha,    Cyrillic_SHA,   guillemotleft,  doublelowquotemark ] };
          key <AD12> { [  Cyrillic_shcha,  Cyrillic_SHCHA,  guillemotright, leftdoublequotemark ] };
          key <BKSL> { [      Cyrillic_e,      Cyrillic_E, rightsinglequotemark, rightdoublequotemark ] };

          key <AC01> { [      Cyrillic_a,      Cyrillic_A,      apostrophe,           U02BC ] }; // modifier letter apostrophe
          key <AC02> { [     Cyrillic_er,     Cyrillic_ER,      registered                  ] };
          key <AC03> { [     Cyrillic_es,     Cyrillic_ES,              at                  ] };
          key <AC04> { [     Cyrillic_te,     Cyrillic_TE,    Serbian_tshe,    Serbian_TSHE ] };
          key <AC05> { [     Cyrillic_de,     Cyrillic_DE,     Serbian_dje,     Serbian_DJE ] };
          key <AC06> { [     Cyrillic_che,   Cyrillic_CHE,   Cyrillic_dzhe,   Cyrillic_DZHE ] };
          key <AC07> { [     Cyrillic_en,     Cyrillic_EN,    Cyrillic_nje,    Cyrillic_NJE ] };
          key <AC08> { [     Cyrillic_ie,     Cyrillic_IE,    Ukrainian_ie,    Ukrainian_IE ] };
          key <AC09> { [      Cyrillic_i,      Cyrillic_I,     Ukrainian_i,     Ukrainian_I ] };
          key <AC10> { [      Cyrillic_o,      Cyrillic_O                                   ] };
          key <AC11> { [ Cyrillic_softsign, Cyrillic_SOFTSIGN, Cyrillic_hardsign, Cyrillic_HARDSIGN ] };

          key <AB01> { [     Cyrillic_ze,     Cyrillic_ZE,   Macedonia_dse,   Macedonia_DSE ] };
          key <AB02> { [     Cyrillic_ha,     Cyrillic_HA                                   ] };
          key <AB03> { [    Cyrillic_tse,    Cyrillic_TSE,       copyright                  ] };
          key <AB04> { [     Cyrillic_ve,     Cyrillic_VE                                   ] };
          key <AB05> { [     Cyrillic_be,     Cyrillic_BE,   Macedonia_gje,   Macedonia_GJE ] };
          key <AB06> { [     Cyrillic_ka,     Cyrillic_KA,   Macedonia_kje,   Macedonia_KJE ] };
          key <AB07> { [     Cyrillic_em,     Cyrillic_EM                                   ] };
          key <AB08> { [           comma,       semicolon,            less                  ] };
          key <AB09> { [          period,           colon,         greater                  ] };
          key <AB10> { [           slash,        question,       backslash,             bar ] };

          key <LSGT> { [ Cyrillic_hardsign, Cyrillic_HARDSIGN,  apostrophe,        quotedbl ] };
      ${"  "}
          key <RALT> {[  ISO_Level3_Shift  ], type[group1]="ONE_LEVEL" };
      };


    '';

    "xkb/rules/evdev.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <xkbConfigRegistry version="1.1">
        <layoutList>
          <layout>
            <configItem>
              <name>en_custom</name>
              <shortDescription>en</shortDescription>
              <description>English (Colemak)</description>
              <countryList><iso3166Id>US</iso3166Id></countryList>
              <languageList><iso639Id>eng</iso639Id></languageList>
            </configItem>
            <variantList>
              <variant>
                <configItem>
                  <name>colemak</name>
                  <shortDescription>en</shortDescription>
                  <description>English (Colemak)</description>
                  <countryList><iso3166Id>US</iso3166Id></countryList>
                  <languageList><iso639Id>eng</iso639Id></languageList>
                </configItem>
              </variant>
            </variantList>
          </layout>
          <layout>
            <configItem>
              <name>ru_custom</name>
              <shortDescription>ru</shortDescription>
              <description>Russian (Rulemak)</description>
              <countryList><iso3166Id>RU</iso3166Id></countryList>
              <languageList><iso639Id>rus</iso639Id></languageList>
            </configItem>
            <variantList>
              <variant>
                <configItem>
                  <name>rulemak</name>
                  <shortDescription>ru</shortDescription>
                  <description>Russian (Rulemak)</description>
                  <countryList><iso3166Id>RU</iso3166Id></countryList>
                  <languageList><iso639Id>rus</iso639Id></languageList>
                </configItem>
              </variant>
            </variantList>
          </layout>
        </layoutList>
      </xkbConfigRegistry>
    '';
  };

  # systemd.user.targets.default.wants = [ "hyprpolkitagent.service" ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  programs = {
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/screenshots";
    };
  };
}
