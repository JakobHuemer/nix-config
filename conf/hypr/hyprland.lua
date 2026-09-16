-- Monitors
local terminal = "ghostty"
local fileManager = "nemo"
local menu = "dmenu-wl_run -i --monitor \"$(hyprctl monitors -j | jq -r '.[] "
    .. "| select(.focused == true) | .name')\""

local MAINMOD = "SUPER"

require("hyprland_config")

hl.monitor({
    output = "DP-2",
    mode = "2560x1440@144",
    position = "2560x0",
    scale = 1,
})

hl.monitor({
    output = "DP-1",
    mode = "3840x2160@160",
    position = "0x0",
    scale = 1.5,
    bitdepth = 10,
})

hl.monitor({
    output = "eDP-1",
    mode = "3024x1890@120",
    position = "0x0",
    scale = 1.5,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-2",
    persistent = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "DP-1",
    persistent = true,
})

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- hyprlock")
    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
end)

-- gb kb layout force for custom keybs
local gb_force_devices = {
    "jakkis-corne",
    "jakkis-corne-consumer-control",
    "jakkis-corne-system-control",
    "jakkis-corne-keyboard",
}

for _, device in ipairs(gb_force_devices) do
    hl.device({
        name = device,
        kb_layout = "gb",
        kb_variant = "",
        kb_options = "",
    })
end

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- LAPTOP TOUCHPAD

hl.device({
    name = "apple-mtp-multi-touch",
    sensitivity = -0.2,
})

require("toggle_touchpad")

-- keybinds

hl.bind(MAINMOD .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(MAINMOD .. " + Q", hl.dsp.window.close())
hl.bind(MAINMOD .. " + F4", hl.dsp.window.kill())
hl.bind(MAINMOD .. " + M", hl.dsp.exit())
hl.bind(MAINMOD .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(MAINMOD .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MAINMOD .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(MAINMOD .. " + U", hl.dsp.layout("togglesplit"))
hl.bind(MAINMOD .. " + I", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(MAINMOD .. " + A", hl.dsp.exec_cmd("pidof pavucontrol && pkill pavucontrol || pavucontrol"))
hl.bind(MAINMOD .. " + W", hl.dsp.exec_cmd("wpaperctl next-wallpaper"))
hl.bind(MAINMOD .. " + SHIFT + W", hl.dsp.exec_cmd("wpaperctl previous-wallpaper"))

-- Move focus with mainmod + arrow keys
hl.bind(MAINMOD .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(MAINMOD .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(MAINMOD .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(MAINMOD .. " + down", hl.dsp.focus({ direction = "down" }))
-- vim moves
hl.bind(MAINMOD .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(MAINMOD .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(MAINMOD .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(MAINMOD .. " + J", hl.dsp.focus({ direction = "down" }))

-- swap windows
hl.bind(MAINMOD .. " + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(MAINMOD .. " + CTRL + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(MAINMOD .. " + CTRL + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(MAINMOD .. " + CTRL + L", hl.dsp.window.move({ direction = "right" }))

-- resize active
hl.bind(MAINMOD .. " + SHIFT + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(MAINMOD .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind(MAINMOD .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(MAINMOD .. " + SHIFT + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

-- Switch workspaces with mainmod + [0-9]
-- Move active window to a workspace with mainmod + SHIFT + [0-9]
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(MAINMOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(MAINMOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- misc binds
hl.bind(MAINMOD .. " + F", hl.dsp.window.fullscreen())
hl.bind(MAINMOD .. " + X", hl.dsp.window.alter_zorder({ mode = "top" }))
hl.bind(MAINMOD .. " + C", hl.dsp.window.toggle_swallow())

-- Move/resize windows with mainmod + LMB/RMB and dragging
hl.bind(MAINMOD .. " + mouse:272", hl.dsp.window.drag())
hl.bind(MAINMOD .. " + mouse:273", hl.dsp.window.resize())

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind(
    "SHIFT + XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -d kbd_backlight set -e4 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "SHIFT + XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -d kbd_backlight -e4 set 5%-"),
    { locked = true, repeating = true }
)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Rules

-- Smart Gaps

for _, ws in ipairs({ "w[tv1]", "f[1]" }) do
    hl.workspace_rule({ workspace = ws, gaps_in = 0, gaps_out = 0 })
    hl.window_rule({ match = { float = false, workspace = ws }, border_size = 0 })
    hl.window_rule({ match = { float = false, workspace = ws }, rounding = 0 })
end

-- opacity blocklist

local opacity_blacklist = {
    "jetbrains-idea",
    "jetbrains-toolbox",
    "jetbrains-webstorm",
    "jetbrains-rustrover",
    "jetbrains-datagrip",
}

for _, class in ipairs(opacity_blacklist) do
    hl.window_rule({
        match = { class = "^(" .. class .. ")$" },
        opacity = "1.0 override 1.0 override",
    })
end

-- floats

local floats = {
    "zen-beta",
    "org.prismlauncher.PrismLauncher",
    "org.pulseaudio.pavucontrol",
}

for _, class in ipairs(floats) do
    hl.window_rule({
        match = { class = "^(" .. class .. ")$" },
        float = true,
    })
end
