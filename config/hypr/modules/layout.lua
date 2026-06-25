-- Градиентная обводка активного окна — три СОЧНЫХ реальных цвета обоев из
-- wallust (WColors.color4/5/6), перелив под углом 45°. matugen scheme-content
-- даёт приглушённую палитру, поэтому для рамки берём wallust; фолбэк — роли
-- matugen (Colors). Перекрашивается сама при смене обоев: WColors из
-- modules/wallust_colors.lua, Colors из modules/generated_colors.lua.
-- NB: reload_hyprland в ~/.local/bin/theme-apply дублирует этот список
-- (читает ~/.cache/wallust/colors.sh) — менять синхронно.
local active_gradient = {
  colors = {
    WColors.color4 or Colors.primary or "rgba(b3c5ffff)",
    WColors.color5 or Colors.secondary or "rgba(b4c5ffff)",
    WColors.color6 or Colors.tertiary or "rgba(e2bbdcff)",
  },
  angle = 45,
}

hl.config({
  general = {
    gaps_in = 8,
    gaps_out = 16,
    border_size = 2,
    resize_on_border = true,       -- тянуть край окна для ресайза
    extend_border_grab_area = 15,  -- невидимая зона захвата вокруг тонкой рамки
    layout = "dwindle",
    col = {
      active_border = active_gradient,
      inactive_border = Colors.background_75 or "rgba(1e1e2ebf)",
    },
  },

  decoration = {
    rounding = 18,
    rounding_power = 4.4,
    active_opacity = 0.95,
    inactive_opacity = 0.86,
    fullscreen_opacity = 0.9,
    dim_special = 0.25,
    dim_strength = 0.25,
    blur = {
      enabled = true,
      brightness = 0.77,
      contrast = 0.84,
      noise = 0.007,
      size = 2,
      passes = 2,
      new_optimizations = true,
    },
    shadow = {
      enabled = true,
      color = 0xac090202,
      color_inactive = 0xac090202,
      offset = "1 2",
      range = 14,
      render_power = 4,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {},

  xwayland = {
    force_zero_scaling = true,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    vrr = 0,
  },
})

hl.curve("MySmooth", { type = "bezier", points = { {0.0, 0.984}, {0.288, 1.001} } })
hl.curve("smooth", { type = "bezier", points = { {0.05, 0.82}, {0.28, 0.97} } })
hl.curve("overshoot", { type = "bezier", points = { {0, 1.6}, {0.28, 1} } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 6.0, bezier = "MySmooth", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6.0, bezier = "MySmooth", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "layers", enabled = true, speed = 8.0, bezier = "MySmooth", style = "slide" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.5, bezier = "MySmooth", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4.0, bezier = "MySmooth", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "default", style = "slidefade" })
