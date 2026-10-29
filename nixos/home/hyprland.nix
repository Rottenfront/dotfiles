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
  ];

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
      terminal = "kitty";

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
                hl.exec_cmd("noctalia")
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
              (mkCmdBind [ mod "B" ] "noctalia msg bar-toggle" null)
              (mkCmdBind [ mod "V" ] "noctalia msg panel-open clipboard" null)
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
    noctalia.enable = true;
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/screenshots";
    };
  };
}
