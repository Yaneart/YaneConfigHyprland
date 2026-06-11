local ok, generated = pcall(require, "modules.generated_colors")

local fallback = {
  image = "",
  primary = "rgba(8aadf4ff)",
  background = "rgba(1e1e2eff)",
  background_75 = "rgba(1e1e2ebf)",
  surface = "rgba(24273aff)",
  surface_container_low = "rgba(363a4fff)",
  surface_container = "rgba(494d64ff)",
  on_surface = "rgba(cad3f5ff)",
}

Colors = ok and generated or fallback

