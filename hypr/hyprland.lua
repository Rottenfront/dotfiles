hl.env('XCURSOR_SIZE', "24")
hl.env('HYPRCURSOR_SIZE', "24")
hl.env('QT_QPA_PLATFORM', "wayland:xcb")
hl.env('QT_QPA_PLATFORMTHEME', "qt5ct:qt6ct")
hl.env('SDL_VIDEODRIVER', "wayland,x11")
hl.env('QT_WAYLAND_DISABLE_WINDOWDECORATION', "1")
hl.env('QT_AUTO_SCREEN_SCALE_FACTOR', "1")
hl.env('PROTON_ENABLE_WAYLAND', "1")
hl.env('NIXOS_OZONE_WL', "1")

local set_edp = function(disabled, resolution, scale)
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



hl.on("hyprland.start", (function()
    --- Software
    hl.exec_cmd("hyprpolkitagent")
    hl.exec_cmd("qs")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd(
        "systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE DISPLAY XDG_CURRENT_DESKTOP && systemctl --user restart cliphist.service cliphist-images.service")
end
))

set_edp(false, '2880x1800@60', '1.5')

hl.config({
    animations = {
        enabled = true
    },
    decoration = {
        active_opacity = 1.0,
        blur = {
            enabled = true,
            new_optimizations = true,
            passes = 5,
            size = 3,
            vibrancy = 0.0
        },
        inactive_opacity = 1.0,
        rounding = 7,
        shadow = {
            enabled = false
        }
    },
    dwindle = {
        preserve_split = true
    },
    ecosystem = {
        enforce_permissions = false,
        no_update_news = true
    },
    general = {
        allow_tearing = true,
        border_size = 1,
        col = {
            active_border = "#889392",
            inactive_border = "#0e1514"
        },
        gaps_in = 3,
        gaps_out = 3,
        layout = "dwindle",
        resize_on_border = false
    },
    input = {
        accel_profile = "flat",
        follow_mouse = 1,
        kb_layout = "en_custom,ru_custom",
        kb_model = "",
        kb_options = "grp:caps_toggle,grp:win_space_toggle",
        kb_rules = "",
        kb_variant = "colemak,rulemak",
        touchpad = {
            natural_scroll = true
        }
    },
    master = {
        new_status = "master"
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0
    },
    scrolling = {
        fullscreen_on_one_column = true
    },
    xwayland = {
        force_zero_scaling = true
    }
})

-- Brief, purposeful motion inspired by Apple's HIG (timings are local choices):
-- https://developer.apple.com/design/human-interface-guidelines/motion
-- 1 = normal, 2 = twice as fast, 0.5 = half speed; must be positive.
local animationSpeed = 2.5
assert(animationSpeed > 0, "animationSpeed must be positive")

hl.curve("motion", { type = "bezier", points = { { 0.42, 0 }, { 0.58, 1 } } })

-- Hyprland's speed field is a duration in deciseconds, so divide by the multiplier.
local animate = function(leaf, durationMs, style)
    hl.animation({
        leaf = leaf,
        enabled = true,
        speed = durationMs / (100 * animationSpeed),
        bezier = "motion",
        style = style,
    })
end

animate("global", 200)
animate("border", 150)
animate("windows", 200)
animate("windowsIn", 200, "popin 95%")
animate("windowsOut", 200, "popin 95%")
animate("windowsMove", 200)
animate("fade", 150)
animate("fadeIn", 150)
animate("fadeOut", 150)
animate("layers", 200, "fade")
animate("layersIn", 200, "fade")
animate("layersOut", 200, "fade")
animate("fadeLayersIn", 150)
animate("fadeLayersOut", 150)
animate("workspaces", 250, "slide")
animate("specialWorkspace", 250, "slidevert")
animate("zoomFactor", 200)

hl.gesture({
    action = "workspace",
    direction = "horiz",
    fingers = 3
})

local mod = "SUPER + "
local mod2 = "SHIFT + "
local mod3 = "CTRL + "
local mod4 = "ALT + "

for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    hl.bind(mod .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. mod2 .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mod .. "C", (hl.dsp.exec_cmd('rofi -show drun')))
hl.bind(mod .. "B", (hl.dsp.exec_cmd('qs ipc call bar toggle')))
hl.bind(mod .. "P", (hl.dsp.exec_cmd('qs ipc call ctrl toggle')))
hl.bind(mod .. mod2 .. "V", (hl.dsp.exec_cmd('qs ipc call musicVis toggle')))
hl.bind(mod .. "V", (hl.dsp.exec_cmd('qs ipc call clipboard toggle')))
hl.bind(mod .. "N", (hl.dsp.exec_cmd('qs ipc call notifications toggle')))
hl.bind(mod .. "M", (hl.dsp.exec_cmd('qs ipc call music toggle')))
hl.bind(mod .. "T", (hl.dsp.exec_cmd('ghostty')))
hl.bind(mod .. mod2 .. "T", (hl.dsp.exec_cmd('ghostty -e tmux')))
hl.bind(mod .. mod2 .. "N", (hl.dsp.exec_cmd('neovide')))
hl.bind(mod .. mod2 .. "B", (hl.dsp.exec_cmd('firefox')))
hl.bind(mod .. mod2 .. "I", (hl.dsp.exec_cmd('chrome')))
hl.bind(mod .. "G", (hl.dsp.workspace.toggle_special('music')))
hl.bind(mod .. mod2 .. "G", (hl.dsp.window.move({ workspace = 'special:music' })))
hl.bind(mod .. mod3 .. "G", (hl.dsp.exec_cmd('ghostty -e termusic')))
hl.bind(mod .. mod2 .. "P", (hl.dsp.exec_cmd('pwvucontrol')))
hl.bind(mod .. "D", (hl.dsp.workspace.toggle_special('magic')))
hl.bind(mod .. mod2 .. "D", (hl.dsp.window.move({ workspace = 'special:magic' })))
hl.bind(mod .. "SEMICOLON", (function()
    local current, _ = hl.get_config('general:layout')
    if current == 'dwindle' then
        hl.config({ general = { layout = 'scrolling' } })
    else
        hl.config({ general = { layout = 'dwindle' } })
    end
end
))
hl.bind(mod .. mod2 .. "SEMICOLON", (function()
    hl.config({ general = { layout = 'dwindle' } })
end
))
hl.bind(mod .. "F", (hl.dsp.window.float({ action = 'toggle' })))
hl.bind(mod .. "U", (hl.dsp.window.fullscreen({ action = 'toggle' })))
hl.bind(mod .. mod2 .. "C", (hl.dsp.window.close()))
hl.bind(mod .. "H", (hl.dsp.focus({ direction = 'left' })))
hl.bind(mod .. "L", (hl.dsp.focus({ direction = 'right' })))
hl.bind(mod .. "K", (hl.dsp.focus({ direction = 'up' })))
hl.bind(mod .. "J", (hl.dsp.focus({ direction = 'down' })))
hl.bind(mod .. mod2 .. "H", (hl.dsp.window.move({ direction = 'left' })))
hl.bind(mod .. mod2 .. "L", (hl.dsp.window.move({ direction = 'right' })))
hl.bind(mod .. mod2 .. "K", (hl.dsp.window.move({ direction = 'up' })))
hl.bind(mod .. mod2 .. "J", (hl.dsp.window.move({ direction = 'down' })))
hl.bind(mod .. mod4 .. "H", (hl.dsp.window.resize({ x = -10, y = 0, relative = true })), ({ repeating = true }))
hl.bind(mod .. mod4 .. "L", (hl.dsp.window.resize({ x = 10, y = 0, relative = true })), ({ repeating = true }))
hl.bind(mod .. mod4 .. "K", (hl.dsp.window.resize({ x = 0, y = -20, relative = true })), ({ repeating = true }))
hl.bind(mod .. mod4 .. "J", (hl.dsp.window.resize({ x = 0, y = 20, relative = true })), ({ repeating = true }))
hl.bind(mod .. "mouse:272", (hl.dsp.window.drag()), ({ mouse = true }))
hl.bind(mod .. "mouse:273", (hl.dsp.window.resize()), ({ mouse = true }))
hl.bind(mod .. "O", (hl.dsp.layout('togglesplit')))
hl.bind(mod .. mod3 .. "F1", (function()
    set_edp(false, '2880x1800@60', '1.5')

    hl.exec_cmd('notify-send "eDP display resolution" "Display resolution: 2880x1800@60"')
end
))
hl.bind(mod .. mod3 .. "F2", (function()
    set_edp(false, '2880x1800@120', '1.5')

    hl.exec_cmd('notify-send "eDP display resolution" "Display resolution: 2880x1800@120"')
end
))
hl.bind(mod .. mod3 .. "F3", (function()
    set_edp(false, '1920x1200@120', '1')

    hl.exec_cmd('notify-send "eDP display resolution" "Display resolution: 1920x1200@120"')
end
))
hl.bind(mod .. mod3 .. "F4", (function()
    set_edp(true, "", "")

    hl.exec_cmd('notify-send "eDP display disabled"')
end
))
hl.bind("XF86AudioRaiseVolume", (hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+')),
    ({ locked = true, repeating = true }))
hl.bind("XF86AudioLowerVolume", (hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')),
    ({ locked = true, repeating = true }))
hl.bind("XF86AudioMute", (hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')),
    ({ locked = true, repeating = true }))
hl.bind("XF86AudioMicMute", (hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle')),
    ({ locked = true, repeating = true }))
hl.bind("XF86AudioPause", (hl.dsp.exec_cmd('playerctl pause')), ({ locked = true }))
hl.bind("XF86AudioNext", (hl.dsp.exec_cmd('playerctl next')), ({ locked = true }))
hl.bind("XF86AudioPlay", (hl.dsp.exec_cmd('playerctl play-pause')), ({ locked = true }))
hl.bind("XF86AudioPrev", (hl.dsp.exec_cmd('playerctl previous')), ({ locked = true }))
hl.bind("XF86MonBrightnessUp", (hl.dsp.exec_cmd('brightnessctl s 5%+')), ({ locked = true }))
hl.bind("XF86MonBrightnessDown", (hl.dsp.exec_cmd('brightnessctl s 5%-')), ({ locked = true }))
hl.bind(mod .. "F1", (hl.dsp.exec_cmd('playerctl previous')))
hl.bind(mod .. "F2", (hl.dsp.exec_cmd('playerctl play-pause')))
hl.bind(mod .. "F3", (hl.dsp.exec_cmd('playerctl next')))
hl.bind(mod .. mod2 .. "COMMA", (hl.dsp.exec_cmd('hl.dsp.exit()')))
hl.bind(mod .. mod2 .. "S", (hl.dsp.exec_cmd('hyprshot -z -m region -o "$HOME/Pictures/screenshots"')))
hl.bind("Print", (hl.dsp.exec_cmd('hyprshot -z -m region -o "$HOME/Pictures/screenshots"')))

hl.window_rule({
    match = {
        class = ".*"
    },
    name = "suppress-maximize-events",
    suppress_event = "maximize"
})
hl.window_rule({
    match = {
        class = "^$",
        float = true,
        fullscreen = false,
        pin = false,
        title = "^$",
        xwayland = true
    },
    name = "fix-xwayland-drags",
    no_focus = true
})
hl.window_rule({
    border_size = 0,
    float = true,
    fullscreen = true,
    match = {
        class = "gamescope"
    },
    name = "gamescope fixes",
    no_anim = true,
    no_shadow = true,
    rounding = 0
})
hl.window_rule({
    float = true,
    match = {
        class = "hyprland-run"
    },
    move = "20 monitor_h-120",
    name = "move-hyprland-run"
})
hl.window_rule({
    border_size = 0,
    match = {
        float = false,
        workspace = "w[tv1]"
    }
})
hl.window_rule({
    border_size = 0,
    match = {
        float = false,
        workspace = "f[1]"
    }
})
hl.window_rule({
    float = true,
    match = {
        class = "naps2"
    },
    name = "naps"
})
hl.window_rule({
    center = true,
    float = true,
    match = {
        class = "xdg-desktop-portal.*"
    },
    name = "xdg",
    size = {
        "(monitor_w*0.5)",
        "(monitor_h*0.6)"
    }
})
hl.window_rule({
    float = true,
    match = {
        title = "Picture-in-Picture"
    },
    name = "picture in picture"
})
hl.window_rule({
    float = true,
    match = {
        title = "(Rename .*)|(File Operation Progress)"
    },
    name = "thunar utilities"
})
hl.window_rule({
    float = true,
    match = {
        class = "PortProton"
    },
    name = "portproton"
})
hl.window_rule({
    match = {
        class = "Happ"
    },
    name = "vpn",
    workspace = 10
})
hl.window_rule({
    match = {
        class = "(org.kde.easyeffects)|(com.saivert.pwvucontrol)"
    },
    name = "audio stuff",
    workspace = 9
})
