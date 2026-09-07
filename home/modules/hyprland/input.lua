-- -------------------------------------------------------------------
-- INPUT
-- -------------------------------------------------------------------

hl.config({
    input = {
        -- Keyboard
        kb_layout = "us",
        repeat_rate = 30,
        repeat_delay = 300,

        -- Pointer
        sensitivity = 0.0,
        accel_profile = "adaptive",

        -- Focus
        focus_on_close = 2,

        -- Touchpad
        touchpad = {
            tap_to_click = true,
            tap_and_drag = true,
            disable_while_typing = true,

            clickfinger_behavior = true,

            natural_scroll = false,
            scroll_factor = 1.0,
        },
    },
})
