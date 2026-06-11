hl.layer_rule({
  match = { namespace = "rofi" },
  blur = true,
  ignore_alpha = 0.7,
})

hl.layer_rule({
  match = { namespace = "waybar" },
  blur = true,
  ignore_alpha = 0,
})

hl.layer_rule({
  match = { namespace = "swaync-notification-window" },
  animation = "slide right",
})

hl.layer_rule({
  match = { namespace = "swaync-control-center" },
  animation = "slide right",
})

hl.window_rule({
  name = "android-studio-helper-float",
  match = {
    class = "^(jetbrains-.*|android-studio)$",
    title = "^(win[0-9]+)$",
  },
  float = true,
  no_focus = true,
  rounding = 20,
  decorate = true,
  border_size = 2,
})

hl.window_rule({
  name = "desktopeditors-fix",
  match = { class = "^(DesktopEditors)$" },
  float = true,
  center = true,
  monitor = "current",
  workspace = "unset",
})
