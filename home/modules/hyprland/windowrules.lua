-- -------------------------------------------------------------------
-- WINDOW RULES
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- PICTURE-IN-PICTURE
-- -------------------------------------------------------------------

-- Firefox Picture-in-Picture
hl.window_rule({
    name = "firefox-pip",

    match = {
        initial_class = "^firefox$",
        initial_title = "^Picture-in-Picture$",
    },

    float = true,
    pin = true,
    center = true,

    size = {
        "monitor_w * 0.30",
        "monitor_h * 0.30",
    },
})

-- Brave Picture-in-Picture
hl.window_rule({
    name = "brave-pip",

    match = {
        initial_title = "^Picture in picture$",
    },

    float = true,
    pin = true,
    center = true,

    size = {
        "monitor_w * 0.30",
        "monitor_h * 0.30",
    },
})

-- -------------------------------------------------------------------
-- FILE PICKERS
-- -------------------------------------------------------------------

-- Open file dialog
hl.window_rule({
    name = "file-picker-open",

    match = {
        initial_class = "^xdg-desktop-portal-gtk$",
        initial_title = "^Open File.*$",
    },

    float = true,
    center = true,

    size = {
        "monitor_w * 0.65",
        "monitor_h * 0.70",
    },
})

-- Save file dialog
hl.window_rule({
    name = "file-picker-save",

    match = {
        initial_class = "^xdg-desktop-portal-gtk$",
        initial_title = "^(Save.*|.* wants to save)$",
    },

    float = true,
    center = true,

    size = {
        "monitor_w * 0.65",
        "monitor_h * 0.70",
    },
})
