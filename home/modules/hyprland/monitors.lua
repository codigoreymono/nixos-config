-- -------------------------------------------------------------------
-- MONITORS
-- -------------------------------------------------------------------

-- Main monitor
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60.01",
    position = "0x0",
    scale = 1,
})

-- Secundary monitor
hl.monitor({
    output = "DP-2",
    mode = "1360x768@60.02",
    position = "1920x0",
    scale = 1,
})

-- Fallback for any other monitor
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})
