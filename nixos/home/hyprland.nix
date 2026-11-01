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
    MANGOHUD = "1";
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
    gawk
    gnused
    procps
  ];

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

  wayland.windowManager.hyprland =
    let
      concatToKeymap = lib.concatStringsSep " + ";

      mkBind = keys: action: opts: {
        _args = [
          (concatToKeymap keys)
          (lib.generators.mkLuaInline action)
        ]
        ++ lib.optional (opts != null) (lib.generators.mkLuaInline opts);
      };

      mod = "SUPER";
      mod2 = "SHIFT";
      mod3 = "CTRL";
      mod4 = "ALT";
      # terminal = "kitty";
      terminal = "alacritty";

      mkCmdBind =
        keys: cmd: opts:
        mkBind keys "hl.dsp.exec_cmd('${cmd}')" opts;
    in
    {
      enable = true;

      systemd.enable = false;

      settings = {
        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                --- Software
                hl.exec_cmd("hyprpolkitagent")
                hl.exec_cmd("qs")
                hl.exec_cmd("hyprpaper")

                --- Displays
                hl.monitor({
                    output   = "eDP-1",
                    disabled = false,
                    mode     = "2880x1800@60",
                    bitdepth = 10,
                    position = "3440x0",
                    scale    = "1.5",
                })

                hl.monitor({
                    output   = "DP-3",
                    mode     = "3440x1440@100",
                    position = "0x0",
                    scale    = "1",
                })
              end
            '')
          ];
        };

        config = {
          ecosystem = {
            enforce_permissions = false;
            no_update_news = true;
          };
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };
          xwayland = {
            force_zero_scaling = true;
          };
          general = {
            gaps_in = 0;
            gaps_out = 0;

            border_size = 1;
            col = {
              active_border = "#889392";
              inactive_border = "#0e1514";
            };

            resize_on_border = false;

            allow_tearing = true;

            layout = "dwindle";
          };

          decoration = {
            rounding = 0;
            # rounding_power = 10;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = false;
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 4;
              new_optimizations = true;
              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = false;
          };

          # Layouts
          dwindle = {
            preserve_split = true;
          };
          master = {
            new_status = "master";
          };
          scrolling = {
            fullscreen_on_one_column = true;
          };

          input = {
            kb_layout = "en_custom,ru_custom";
            kb_variant = "colemak,rulemak";
            kb_model = "";
            kb_options = "grp:caps_toggle,grp:win_space_toggle";
            kb_rules = "";

            follow_mouse = 1;

            accel_profile = "flat";

            touchpad = {
              natural_scroll = true;
            };
          };
        };

        gesture = [
          {
            _args = [
              {
                fingers = 3;
                direction = "horiz";
                action = "workspace";
              }
            ];
          }
        ];

        set_edp = {
          _var = (
            lib.generators.mkLuaInline ''
              function(disabled, resolution, scale)
                if disabled then
                  hl.monitor({
                    output   = "eDP-1",
                    disabled = true,
                  })
                else
                  hl.monitor({
                    output   = "eDP-1",
                    disabled = false,
                    mode     = resolution,
                    bitdepth = 10,
                    position = "3440x0",
                    scale    = scale,
                  })
                end

                hl.monitor({
                    output   = "DP-3",
                    mode     = "3440x1440@100",
                    position = "0x0",
                    scale    = "1",
                })
              end
            ''
          );
        };

        bind =
          let
            workspaceBinds = lib.concatMap (
              i:
              let
                key = toString (lib.mod i 10);
                ws = toString i;
              in
              [
                (mkBind [ mod key ] "hl.dsp.focus({ workspace = ${ws} })" null)
                (mkBind [ mod mod2 key ] "hl.dsp.window.move({ workspace = ${ws} })" null)
              ]
            ) (lib.range 1 10);

            applicationBinds = [
              (mkCmdBind [ mod "C" ] "rofi -show drun" null)
              (mkCmdBind [ mod "B" ] "qs ipc call bar toggle" null)
              (mkCmdBind [ mod "P" ] "qs ipc call ctrl toggle" null)
              (mkCmdBind [ mod "V" ] "qs ipc call musicVis toggle" null)
              (mkCmdBind [ mod "T" ] terminal null)
              (mkCmdBind [ mod mod2 "T" ] "${terminal} -e tmux" null)
              (mkCmdBind [ mod mod2 "N" ] "neovide" null)
              (mkCmdBind [ mod mod2 "B" ] "firefox" null)
              (mkCmdBind [ mod mod2 "I" ] "chrome" null)
            ];

            audioBinds = [
              (mkBind [ mod "G" ] "hl.dsp.workspace.toggle_special('music')" null)
              (mkBind [ mod mod2 "G" ] "hl.dsp.window.move({ workspace = 'special:music' })" null)
              (mkCmdBind [ mod mod3 "G" ] "${terminal} -e termusic" null)
              (mkCmdBind [ mod mod2 "P" ] "pwvucontrol" null)

              # scratch workspace
              (mkBind [ mod "D" ] "hl.dsp.workspace.toggle_special('magic')" null)
              (mkBind [ mod mod2 "D" ] "hl.dsp.window.move({ workspace = 'special:magic' })" null)
            ];

            layoutBinds = [
              (mkBind [ mod "SEMICOLON" ] ''
                function()
                  local current, _ = hl.get_config('general:layout')
                  if current == 'dwindle' then
                    hl.config({ general = { layout = 'scrolling' } })
                  else
                    hl.config({ general = { layout = 'dwindle' } })
                  end
                end
              '' null)

              (mkBind [ mod mod2 "SEMICOLON" ] ''
                function()
                  hl.config({ general = { layout = 'dwindle' } })
                end
              '' null)
            ];

            windowBinds = [
              (mkBind [ mod "F" ] "hl.dsp.window.float({ action = 'toggle' })" null)
              (mkBind [ mod "U" ] "hl.dsp.window.fullscreen({ action = 'toggle' })" null)

              (mkBind [ mod mod2 "C" ] "hl.dsp.window.close()" null)

              (mkBind [ mod "H" ] "hl.dsp.focus({ direction = 'left' })" null)
              (mkBind [ mod "L" ] "hl.dsp.focus({ direction = 'right' })" null)
              (mkBind [ mod "K" ] "hl.dsp.focus({ direction = 'up' })" null)
              (mkBind [ mod "J" ] "hl.dsp.focus({ direction = 'down' })" null)

              (mkBind [ mod mod2 "H" ] "hl.dsp.window.move({ direction = 'left' })" null)
              (mkBind [ mod mod2 "L" ] "hl.dsp.window.move({ direction = 'right' })" null)
              (mkBind [ mod mod2 "K" ] "hl.dsp.window.move({ direction = 'up' })" null)
              (mkBind [ mod mod2 "J" ] "hl.dsp.window.move({ direction = 'down' })" null)

              (mkBind [
                mod
                mod4
                "H"
              ] "hl.dsp.window.resize({ x = -10, y = 0, relative = true })" "{ repeating = true }")
              (mkBind [
                mod
                mod4
                "L"
              ] "hl.dsp.window.resize({ x = 10, y = 0, relative = true })" "{ repeating = true }")
              (mkBind [
                mod
                mod4
                "K"
              ] "hl.dsp.window.resize({ x = 0, y = -20, relative = true })" "{ repeating = true }")
              (mkBind [
                mod
                mod4
                "J"
              ] "hl.dsp.window.resize({ x = 0, y = 20, relative = true })" "{ repeating = true }")

              (mkBind [ mod "mouse:272" ] "hl.dsp.window.drag()" "{ mouse = true }")
              (mkBind [ mod "mouse:273" ] "hl.dsp.window.resize()" "{ mouse = true }")

              (mkBind [ mod "O" ] "hl.dsp.layout('togglesplit')" null)
            ];

            eDPBinds = [
              (mkBind [ mod mod3 "F1" ] ''
                function()
                  set_edp(false, '2880x1800@60', '1.5')

                  hl.exec_cmd('notify-send "eDP display resolution" "Display resolution: 2880x1800@60"')
                end
              '' null)
              (mkBind [ mod mod3 "F2" ] ''
                function()
                  set_edp(false, '2880x1800@120', '1.5')

                  hl.exec_cmd('notify-send "eDP display resolution" "Display resolution: 2880x1800@120"')
                end
              '' null)
              (mkBind [ mod mod3 "F3" ] ''
                function()
                  set_edp(false, '1920x1200@120', '1')

                  hl.exec_cmd('notify-send "eDP display resolution" "Display resolution: 1920x1200@120"')
                end
              '' null)
              (mkBind [ mod mod3 "F4" ] ''
                function()
                  set_edp(true, "", "")

                  hl.exec_cmd('notify-send "eDP display disabled"')
                end
              '' null)
            ];

            mediaBinds = [
              (mkCmdBind [
                "XF86AudioRaiseVolume"
              ] "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" "{ locked = true, repeating = true }")

              (mkCmdBind [
                "XF86AudioLowerVolume"
              ] "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" "{ locked = true, repeating = true }")

              (mkCmdBind [
                "XF86AudioMute"
              ] "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" "{ locked = true, repeating = true }")

              (mkCmdBind [
                "XF86AudioMicMute"
              ] "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" "{ locked = true, repeating = true }")

              (mkCmdBind [ "XF86AudioPause" ] "playerctl pause" "{ locked = true }")
              (mkCmdBind [ "XF86AudioNext" ] "playerctl next" "{ locked = true }")
              (mkCmdBind [ "XF86AudioPlay" ] "playerctl play-pause" "{ locked = true }")
              (mkCmdBind [ "XF86AudioPrev" ] "playerctl previous" "{ locked = true }")

              (mkCmdBind [ "XF86MonBrightnessUp" ] "brightnessctl s 5%+" "{ locked = true }")
              (mkCmdBind [ "XF86MonBrightnessDown" ] "brightnessctl s 5%-" "{ locked = true }")

              (mkCmdBind [ mod "F1" ] "playerctl previous" null)
              (mkCmdBind [ mod "F2" ] "playerctl play-pause" null)
              (mkCmdBind [ mod "F3" ] "playerctl next" null)
            ];
          in
          workspaceBinds
          ++ applicationBinds
          ++ audioBinds
          ++ layoutBinds
          ++ windowBinds
          ++ eDPBinds
          ++ mediaBinds
          ++ [
            (mkCmdBind [ mod mod2 "COMMA" ] "hl.dsp.exit()" null)

            (mkCmdBind [ mod mod2 "S" ] "hyprshot -z -m region" null)
            (mkCmdBind [ "Print" ] "hyprshot -z -m region" null)
          ];

        window_rule =
          let
            mkWindowRule = inner: {
              _args = [ inner ];
            };
          in
          [

            (mkWindowRule {
              name = "suppress-maximize-events";
              match.class = ".*";
              suppress_event = "maximize";
            })

            (mkWindowRule {
              name = "fix-xwayland-drags";
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };

              no_focus = true;
            })

            (mkWindowRule {
              name = "gamescope fixes";
              match.class = "gamescope";
              float = true;
              fullscreen = true;
              border_size = 0;
              no_anim = true;
              no_shadow = true;
              rounding = 0;
            })

            (mkWindowRule {
              name = "move-hyprland-run";
              match.class = "hyprland-run";

              move = "20 monitor_h-120";
              float = true;
            })

            # Smart borders: no border when only one window
            (mkWindowRule {
              match = {
                float = false;
                workspace = "w[tv1]";
              };
              border_size = 0;
            })
            (mkWindowRule {
              match = {
                float = false;
                workspace = "f[1]";
              };
              border_size = 0;
            })

            (mkWindowRule {
              name = "naps";
              match.class = "naps2";

              float = true;
            })

            (mkWindowRule {
              name = "xdg";
              match.class = "xdg-desktop-portal.*";
              float = true;
              size = [
                "(monitor_w*0.5)"
                "(monitor_h*0.6)"
              ];
              center = true;
            })

            (mkWindowRule {
              name = "picture in picture";
              match.title = "Picture-in-Picture";
              float = true;
            })

            (mkWindowRule {
              name = "thunar utilities";
              match.title = "(Rename .*)|(File Operation Progress)";
              float = true;
            })

            (mkWindowRule {
              name = "portproton";
              match.class = "PortProton";
              float = true;
            })

            (mkWindowRule {
              name = "vpn";
              match.class = "Happ";
              workspace = 10;
            })

            (mkWindowRule {
              name = "audio stuff";
              match.class = "(org.kde.easyeffects)|(com.saivert.pwvucontrol)";
              workspace = 9;
            })
          ];
      };
    };

  programs = {
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/screenshots";
    };
  };
}
