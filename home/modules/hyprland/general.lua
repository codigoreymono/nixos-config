-- -------------------------------------------------------------------
-- GENERAL
-- -------------------------------------------------------------------

hl.config({
    general = {
        -- Window layout
        layout = "dwindle",

        -- Window spacing
        gaps_in = 1,
        gaps_out = 1,

        -- Borders
        border_size = 2,

        -- Allow resizing by dragging window borders/gaps
        resize_on_border = true,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,

        -- Keep tearing disabled globally
        allow_tearing = false,
    },

    -- ----------------------------------------------------------------
    -- DWINDLE
    -- ----------------------------------------------------------------

    dwindle = {
        -- Keep new splits predictable.
        preserve_split = true,

        -- New windows use the currently focused window
        -- as the basis for the next split.
        use_active_for_splits = true,

        -- Equal split by default.
        default_split_ratio = 1.0,

        -- Makes resizing behave naturally between neighboring windows.
        smart_resizing = true,
    },

    binds = {
        focus_preferred_method = 1,


    },

})
