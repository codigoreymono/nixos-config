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

-- -------------------------------------------------------------------
-- TUI POPUPS
-- -------------------------------------------------------------------

-- Wi-Fi manager
hl.window_rule({
    name = "wifitui",

    match = {
        initial_class = "^wifitui$",
    },

    float = true,
    center = true,

    size = {
        "monitor_w * 0.50",
        "monitor_h * 0.60",
    },
})

-- Audio manager
hl.window_rule({
    name = "wiremix",

    match = {
        initial_class = "^wiremix$",
    },

    float = true,
    center = true,

    size = {
        "monitor_w * 0.55",
        "monitor_h * 0.65",
    },
})

-- Mako notification center
hl.window_rule({
    name = "mako-history",
    match = { initial_class = "^mako-history$" },
    float = true,
    center = true,
    size = { "monitor_w * 0.45", "monitor_h * 0.55" },
})

-- calcurse
hl.window_rule({
    name = "calcurse",
    match = { initial_class = "^calcurse$" },
    float = true,
    center = true,
    size = { "monitor_w * 0.50", "monitor_h * 0.60" },
})

-- jolt
hl.window_rule({
    name = "jolt",
    match = { initial_class = "^jolt$" },
    float = true,
    center = true,
    size = { "monitor_w * 0.55", "monitor_h * 0.65" },
})

-- tray-tui
hl.window_rule({
    name = "tray-tui",
    match = { initial_class = "^tray-tui$" },
    float = true,
    center = true,
    size = { "monitor_w * 0.55", "monitor_h * 0.65" },
})
