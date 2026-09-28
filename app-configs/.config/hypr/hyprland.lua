-- hyprland.lua
-- Converted from hyprland.conf (hyprlang -> Lua config, Hyprland 0.55+)
-- Place at ~/.config/hypr/hyprland.lua
-- Ref: https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({
    output = "DP-1",
    mode = "2560x1440@240",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@144",
    position = "auto-center-left",
    scale = 1,
    transform = 1
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("XCURSOR_THEME", "Papirus")

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -o DP-1 -i /home/ayris/Pictures/wallpapers/earth_c.jpg -m fill -o HDMI-A-1 -i /home/ayris/Pictures/wallpapers/earth_l.jpg")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("fcitx5")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 2,
        border_size = 0,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 5,

        -- Change transparency of focused and unfocused windows
        active_opacity = 0.95,
        inactive_opacity = 0.95,

        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        -- https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled = true,
            size = 3,
            passes = 3,
            vibrancy = 0.1696,
        },
    },

    cursor = {
        no_hardware_cursors = true,
        use_cpu_buffer = true,
    },
})

require("animations")

hl.config({
    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_autoreload = false,
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = -0.9,
    },
})

-- Per-device config
hl.device({
    name = "epic-mouse-v1",
    sensitivity = 0.1,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("alacritty -e fish -c spf"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exit())

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("qs ipc call applauncher toggle"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("qs ipc call sidepannel toggle"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("qs ipc call top_hud toggle"))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Volume controls using pamixer (for PipeWire)
hl.bind("F5", hl.dsp.exec_cmd("pamixer -d 5")) -- Volume down
hl.bind("F6", hl.dsp.exec_cmd("pamixer -i 5")) -- Volume up
hl.bind("F7", hl.dsp.exec_cmd("pamixer -t"))   -- Toggle mute

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("grimblast copy screen")) -- full screen to clipboard
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grimblast copy area")) -- select region to clipboard
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("grimblast copysave area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png")) -- select region, save + clipboard
