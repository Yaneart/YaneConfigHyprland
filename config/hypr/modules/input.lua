hl.env("XCURSOR_THEME", "breeze")
hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- KVM / software rendering fallback from the original config.
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

hl.config({
  input = {
    kb_layout = "us,ru",
    kb_options = "grp:alt_shift_toggle",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
