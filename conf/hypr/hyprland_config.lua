hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 3,

        border_size = 1,

        col = {
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
                angle = 45,
            },

            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing = false,

        layout = "dwindle",

        no_focus_fallback = true,
    },

    decoration = {
        rounding = 3,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 0.92,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = false,
    },

    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },

    dwindle = {
        preserve_split = true,
        force_split = 0,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_splash_rendering = true,
    },

    input = {
        kb_layout = "de,gb",
        kb_variant = "nodeadkeys,",
        kb_options = "grp:win_space_toggle",

        numlock_by_default = true,

        repeat_rate = 30,
        repeat_delay = 230,

        follow_mouse = 1,

        sensitivity = -0.97,

        touchpad = {
            disable_while_typing = true,

            scroll_factor = 0.1,
            natural_scroll = true,

            tap_to_click = true,
            drag_3fg = 1,
        },
    },
})
