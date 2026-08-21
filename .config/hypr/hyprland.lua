-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM", "wayland:xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct:qt6ct")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("PROTON_ENABLE_WAYLAND", "1")


-----------------------
----- PERMISSIONS -----
-----------------------

hl.config({
    ecosystem = {
        enforce_permissions = false,
    },
})

hl.permission({ binary = "/usr/(bin|local/bin)/hyprlock", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprpm", type = "plugin", mode = "allow" })


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "2880x1800@60",
    -- mode     = "2880x1800@120",
    position = "3440x0",
    scale    = "1.5",
})

hl.monitor({
    output   = "DP-2",
    mode     = "3440x1440@100",
    position = "0x0",
    scale    = "1",
})

-------------------
---- AUTOSTART ----
-------------------


hl.on("hyprland.start", function()
    -- For some reason hyprland does not load plugins at the start
    hl.exec_cmd("hyprpm reload")

    hl.exec_cmd("noctalia")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 2,

        border_size = 1,
        col = {
            active_border = "#889392",
            inactive_border = "#0e1514",
        },

        resize_on_border = false,

        allow_tearing = true,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 10,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled           = true,
            size              = 3,
            passes            = 4,
            new_optimizations = true,
            vibrancy          = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})


-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
-- hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeInOutCubic" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1, 5, bezier = "easeInOutCubic", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "easeInOutCubic", style = "popin 60%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.49, bezier = "easeInOutCubic" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1, bezier = "easeOutQuint", style = "slide" })
-- hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "easeOutQuint"})
-- hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "easeOutQuint"})
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })


hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
    xwayland = {
        force_zero_scaling = true
    }
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "en_custom,ru_custom",
        kb_variant = "colemak,rulemak",
        kb_model = "",
        kb_options = "grp:caps_toggle,grp:win_space_toggle",
        kb_rules = "",

        follow_mouse = 1,

        accel_profile = flat,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace"
})


hl.config({
    plugin = {
        hyprcapture = {
            save_dir = "$XDG_PICTURES_DIR/Screenshots"
        }
    }
})

---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER + "
local mod2 = "SHIFT + "
local mod3 = "CTRL + "
local mod4 = "ALT + "

--- APPLICATIONS

-- application menu
hl.bind(mod .. "C", hl.dsp.exec_cmd("noctalia msg panel-open launcher"))
hl.bind(mod .. "F", hl.dsp.exec_cmd("rofi -show filebrowser"))

-- control center
hl.bind(mod .. "B", hl.dsp.exec_cmd("noctalia msg bar-toggle"))
hl.bind(mod .. "V", hl.dsp.exec_cmd("noctalia msg panel-open clipboard"))
hl.bind("SUPER + SHIFT + F23", hl.dsp.exec_cmd("noctalia msg panel-open control-center"))

-- terminal
hl.bind(mod .. mod2 .. "T", hl.dsp.exec_cmd("alacritty"))

-- browsers
hl.bind(mod .. mod2 .. "B", hl.dsp.exec_cmd("librewolf"))
hl.bind(mod .. mod2 .. "I", hl.dsp.exec_cmd("helium-browser --ozone-platform=wayland"))


-- editors
hl.bind(mod .. mod2 .. "N", hl.dsp.exec_cmd("neovide"))
hl.bind(mod .. mod2 .. "Z", hl.dsp.exec_cmd("zeditor"))

-- screenshots
hl.bind(mod .. mod2 .. "S", function()
    hl.plugin.hyprcapture.open()
end)
hl.bind("Print", function()
    hl.plugin.hyprcapture.open()
end)

-- brainrot
hl.bind(mod .. mod2 .. "U", hl.dsp.exec_cmd('discord --ozone-platform=wayland'))

-- debug tools
hl.bind(mod .. mod2 .. "Q", hl.dsp.exec_cmd('alacritty --hold -e hyprctl clients'))


hl.bind(mod .. mod2 .. "COMMA", hl.dsp.exit())


--- WORKSPACES
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. "" .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. mod2 .. "" .. key, hl.dsp.window.move({ workspace = i }))
end

-- audio
hl.bind(mod .. mod3 .. "G", hl.dsp.exec_cmd("alacritty -e termusic"))
hl.bind(mod .. mod2 .. "P", hl.dsp.exec_cmd("pwvucontrol"))
hl.bind(mod .. "G", hl.dsp.workspace.toggle_special("music"))
hl.bind(mod .. mod2 .. "G", hl.dsp.window.move({ workspace = "special:music" }))

-- scratch workspace
hl.bind(mod .. "D", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. mod2 .. "D", hl.dsp.window.move({ workspace = "special:magic" }))


--- LAYOUTS
hl.bind(mod .. "SEMICOLON", function()
    local current, _ = hl.get_config("general:layout")
    if current == "dwindle" then
        hl.config({ general = { layout = "scrolling" } })
    else
        hl.config({ general = { layout = "dwindle" } })
    end
end)

hl.bind(mod .. mod2 .. "SEMICOLON", function()
    hl.config({ general = { layout = "dwindle" } })
end)

--- WINDOWS
hl.bind(mod .. "T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. "U", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mod .. mod2 .. "C", hl.dsp.window.close())

hl.bind(mod .. "H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. "L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. "K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. "J", hl.dsp.focus({ direction = "down" }))

hl.bind(mod .. mod2 .. "H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. mod2 .. "L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. mod2 .. "K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. mod2 .. "J", hl.dsp.window.move({ direction = "down" }))

hl.bind(mod .. mod4 .. "H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. mod4 .. "L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. mod4 .. "K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mod .. mod4 .. "J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

hl.bind(mod .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- hl.bind(mod .. "O", function()
--     local current, _ = hl.get_config("general:layout")
--     if current == "dwindle" then
--         hl.layout("togglesplit")
--     else
--         hl.config({ general = { layout = "dwindle" } })
--     end
-- end)
hl.bind(mod .. "O", hl.dsp.layout("togglesplit"))


--- MEDIA KEYS
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })

hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true })

hl.bind(mod .. "F1", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mod .. "F2", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mod .. "F3", hl.dsp.exec_cmd("playerctl next"))


local power_state = "low"

hl.bind(mod .. "F12", function()
    if power_state == "notes" then
        power_state = "low"
    elseif power_state == "low" then
        power_state = "lowperf"
    elseif power_state == "lowperf" then
        power_state = "high"
    elseif power_state == "high" then
        power_state = "notes"
    end

    hl.exec_cmd("~/dotfiles/scripts/zenbook_power.sh " .. power_state)
end)

hl.bind(mod .. mod3 .. "F1", function()
    local resolution = "2880x1800@60"
    local scale = "1.5"

    hl.monitor({
        output   = "eDP-1",
        mode     = resolution,
        position = "3440x0",
        scale    = scale,
    })
    hl.exec_cmd("notify-send 'Monitor resolution' 'Monitor resolution: " .. resolution .. "'")
end)
hl.bind(mod .. mod3 .. "F2", function()
    local resolution = "2880x1800@120"
    local scale = "1.5"

    hl.monitor({
        output   = "eDP-1",
        mode     = resolution,
        position = "3440x0",
        scale    = scale,
    })
    hl.exec_cmd("notify-send 'Monitor resolution' 'Monitor resolution: " .. resolution .. "'")
end)
hl.bind(mod .. mod3 .. "F3", function()
    local resolution = "1920x1200@120"
    local scale = "1"

    hl.monitor({
        output   = "eDP-1",
        mode     = resolution,
        position = "3440x0",
        scale    = scale,
    })
    hl.exec_cmd("notify-send 'Monitor resolution' 'Monitor resolution: " .. resolution .. "'")
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

local xwayland_fix = hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

xwayland_fix:set_enabled(true)

hl.window_rule({
    name = "gamescope fixes",
    match = {
        class = "gamescope"
    },
    float = true,
    fullscreen = true,
    border_size = 0,
    no_anim = true,
    no_shadow = true,
    rounding = 0,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
})

-- Smart borders: no border when only one window
hl.window_rule({
    match = {
        float = false,
        workspace = "w[tv1]"
    },
    border_size = 0,
})
hl.window_rule({
    match = {
        float = false,
        workspace = "f[1]"
    },
    border_size = 0,
})

hl.window_rule({
    name = "naps",
    match = {
        class = "naps2",
    },

    float = true,
})

hl.window_rule({
    name = "xdg",
    match = {
        class = "xdg-desktop-portal.*",
    },
    float = true,
    size = { "(monitor_w*0.5)", "(monitor_h*0.6)" },
    center = true,
})

hl.window_rule({
    name = "picture in picture",
    match = {
        title = "Picture-in-Picture",
    },
    float = true
})

hl.window_rule({
    name = "thunar utilities",
    match = {
        title = "(Rename .*)|(File Operation Progress)"
    },
    float = true,
})

hl.window_rule({
    name = "portproton",
    match = {
        class = "PortProton",
    },
    float = true
})


hl.window_rule({
    name = "audio stuff",
    match = {
        class = "(org.kde.easyeffects)|(com.saivert.pwvucontrol)",
    },
    workspace = 9,
})
