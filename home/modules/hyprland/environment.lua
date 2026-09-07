-- -------------------------------------------------------------------
-- ENVIRONMENT
-- -------------------------------------------------------------------

-- Workaround for NixOS Hyprland TZDIR issue.
hl.env("TZDIR", "/etc/zoneinfo")
