-- Реальные цвета обоев из wallust для Hyprland (рамка активного окна).
-- matugen-палитра (scheme-content) приглушённая, поэтому сочные акценты для
-- рамки берём отсюда. Грузится в modules/colors.lua как глобал WColors,
-- конвертируется hex→rgba там же. Перегенерируется при каждом theme-apply.
return {
  background = "{{background}}",
  foreground = "{{foreground}}",
  color0  = "{{color0 }}",
  color1  = "{{color1 }}",
  color2  = "{{color2 }}",
  color3  = "{{color3 }}",
  color4  = "{{color4 }}",
  color5  = "{{color5 }}",
  color6  = "{{color6 }}",
  color7  = "{{color7 }}",
  color8  = "{{color8 }}",
}
