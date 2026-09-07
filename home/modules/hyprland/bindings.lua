-- -------------------------------------------------------------------
-- MAIN KEYBINDS
-- -------------------------------------------------------------------

-- Terminal
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("foot"))

-- Close active window
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Power menu
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("qs -c main ipc call power toggle"))

-- App launcher
hl.bind("SUPER + D", hl.dsp.exec_cmd("uwsm app -- fuzzel"))

-- Clipboard history
hl.bind("SUPER + V", hl.dsp.exec_cmd("uwsm app -- cliphist-fuzzel"))

-- Wallpaper menu
hl.bind("SUPER + W", hl.dsp.exec_cmd("qs -c main ipc call wallpaper toggle"))

-- -------------------------------------------------------------------
-- WINDOW FOCUS
-- Super + I/J/K/L
-- -------------------------------------------------------------------

hl.bind("SUPER + J", hl.dsp.focus({direction = "l"}))
hl.bind("SUPER + K", hl.dsp.focus({direction = "d"}))
hl.bind("SUPER + I", hl.dsp.focus({direction = "u"}))
hl.bind("SUPER + L",hl.dsp.focus({direction = "r"}))

-- -------------------------------------------------------------------
-- WINDOW MOVEMENT
-- Super + Shift + I/J/K/L
-- -------------------------------------------------------------------

hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({direction = "l"}))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({direction = "d"}))
hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({direction = "u"}))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({direction = "r"}))

-- -------------------------------------------------------------------
-- WINDOW SWAP
-- Super + Ctrl + I/J/K/L
-- -------------------------------------------------------------------

hl.bind("SUPER + CTRL + I", hl.dsp.window.swap({direction = "u"}))
hl.bind("SUPER + CTRL + J", hl.dsp.window.swap({direction = "l"}))
hl.bind("SUPER + CTRL + K", hl.dsp.window.swap({direction = "d"}))
hl.bind("SUPER + CTRL + L", hl.dsp.window.swap({direction = "r"}))

-- -------------------------------------------------------------------
-- WINDOW STATE
-- -------------------------------------------------------------------

-- Fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen({mode = "fullscreen"}))

-- Toggle floating
hl.bind("SUPER + SPACE", hl.dsp.window.float())

-- Previous workspace on current monitor
hl.bind("SUPER + TAB", hl.dsp.focus({workspace = "previous_per_monitor"}))

-- -------------------------------------------------------------------
-- WORKSPACES
--
-- Super + number         -> focus workspace
-- Super + Shift + number -> move window to workspace
-- -------------------------------------------------------------------

local workspace_keys = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
}

for workspace, key in ipairs(workspace_keys) do
    -- Focus workspace
    hl.bind(
        "SUPER + " .. key,
        hl.dsp.focus({
            workspace = tostring(workspace)
        })
    )

    -- Move active window to workspace
    hl.bind(
        "SUPER + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = tostring(workspace),
            follow = false
        })
    )
end

-- -------------------------------------------------------------------
-- MOUSE WINDOW MANAGEMENT
-- -------------------------------------------------------------------

-- Super + Left Click -> move window
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {mouse = true})

-- Super + Right Click -> resize window
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {mouse = true})

-- -------------------------------------------------------------------
-- MEDIA KEYS
-- -------------------------------------------------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), {repeating = true, locked = true})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {repeating = true, locked = true})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {locked = true})

-- Microphone
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {locked = true})

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), {repeating = true, locked = true})

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), {repeating = true, locked = true})

-- -------------------------------------------------------------------
-- SCREENSHOTS
-- -------------------------------------------------------------------

-- Region -> clipboard
hl.bind("Print", hl.dsp.exec_cmd("screenshot region clipboard"))

-- Current monitor -> clipboard
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot monitor clipboard"))

-- Region -> file + clipboard
hl.bind("SUPER + Print", hl.dsp.exec_cmd("screenshot region file"))

-- Current monitor -> file + clipboard
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("screenshot monitor file"))
