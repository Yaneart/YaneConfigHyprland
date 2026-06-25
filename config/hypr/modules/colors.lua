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

-- WColors: реальные цвета обоев из wallust (modules/wallust_colors.lua,
-- генерится wallust-шаблоном hypr-colors.lua). matugen scheme-content даёт
-- приглушённую палитру, поэтому сочные акценты (рамка активного окна в
-- layout.lua) берём из wallust. Конвертируем "#rrggbb" → "rgba(rrggbbff)".
local function hex2rgba(h, alpha)
  if type(h) ~= "string" then return nil end
  h = h:gsub("#", ""):lower()
  if #h < 6 then return nil end
  return "rgba(" .. h:sub(1, 6) .. (alpha or "ff") .. ")"
end

local wok, wgen = pcall(require, "modules.wallust_colors")
WColors = {}
if wok and type(wgen) == "table" then
  for k, v in pairs(wgen) do
    WColors[k] = hex2rgba(v)
  end
  WColors.background_75 = hex2rgba(wgen.background, "bf")
end

