local mainMod = "SUPER"
local home = os.getenv("HOME") or "/home/yaneart"
local localBin = home .. "/.local/bin"
local rofiBin = home .. "/.config/rofi/applets/bin"

local function bind(keys, dispatcher, flags)
  hl.bind(keys, dispatcher, flags or {})
end

bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(localBin .. "/kitty-dashboard"))
bind(mainMod .. " + Q", hl.dsp.exec_cmd(localBin .. "/close-window"))
-- Esc закрывает eww-попапы (дашборд/батарея); non_consuming = клавиша всё равно
-- проходит в приложения (vim, меню и т.п. не ломаются).
bind("escape", hl.dsp.exec_cmd(localBin .. "/eww-close-popups"), { non_consuming = true })
-- Аварийный выход, если eww-оверлей завис и ест клики мыши: безусловно убивает
-- все попапы. Esc выше — мягкое закрытие с гардом; это — грубое, на всякий случай.
bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd(localBin .. "/eww-panic"))
bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(rofiBin .. "/powermenu.sh"))
bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

bind(mainMod .. " + ALT + H", hl.dsp.window.swap({ direction = "l" }))
bind(mainMod .. " + ALT + J", hl.dsp.window.swap({ direction = "d" }))
bind(mainMod .. " + ALT + K", hl.dsp.window.swap({ direction = "u" }))
bind(mainMod .. " + ALT + L", hl.dsp.window.swap({ direction = "r" }))
bind(mainMod .. " + F1", hl.dsp.exec_cmd("hyprctl layers > /tmp/hypr_layers.txt"))

bind(mainMod .. " + C", hl.dsp.exec_cmd("Telegram"))
bind(mainMod .. " + Y", hl.dsp.exec_cmd("kitty -e yazi"))
bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
bind(mainMod .. " + V", hl.dsp.exec_cmd("code"))
bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(localBin .. "/rofi-clipboard"))
bind(mainMod .. " + H", hl.dsp.exec_cmd("happ"))
bind(mainMod .. " + P", hl.dsp.exec_cmd("spotify-launcher --skip-update"))
bind(mainMod .. " + O", hl.dsp.exec_cmd("obs"))
bind(mainMod .. " + D", hl.dsp.exec_cmd("kitty -e lazydocker"))
bind(mainMod .. " + Z", hl.dsp.exec_cmd("handy --toggle-transcription"))        -- голосовой ввод: старт/стоп записи
bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("handy --toggle-post-process")) -- то же + AI пост-обработка
bind(mainMod .. " + A", hl.dsp.window.close())
bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(localBin .. "/killall"))

bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("pkill rofi || " .. localBin .. "/launcher"))
bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill rofi || " .. localBin .. "/wallset"))
bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(localBin .. "/theme-random"))
bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("pkill rofi || " .. localBin .. "/waybar-menu"))
bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofimoji --action copy"))

bind(mainMod .. " + J", hl.dsp.layout("swapsplit"))

bind(mainMod .. " + SHIFT + H", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + SHIFT + L", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + SHIFT + K", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + SHIFT + J", hl.dsp.focus({ direction = "d" }))

for i = 1, 10 do
  local key = i % 10
  bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind(mainMod .. " + SHIFT + LEFT", hl.dsp.focus({ workspace = "r-1" }))
bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.focus({ workspace = "r+1" }))
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })   -- Super+ЛКМ — двигать окно
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Super+ПКМ — ресайз окна

bind(mainMod .. " + R", hl.dsp.exec_cmd("pkill waybar; waybar &"))
bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(localBin .. "/theme-restore"))
bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(localBin .. "/theme-random"))
bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(localBin .. "/colorscheme-set"))
bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
bind(mainMod .. " + S", hl.dsp.exec_cmd(localBin .. "/toggle-hyprsunset"))
bind(mainMod .. " + CTRL + UP", hl.dsp.exec_cmd("bash ~/.config/waybar/scripts/waybar-light-controls/temperature_control.sh up"))
bind(mainMod .. " + CTRL + DOWN", hl.dsp.exec_cmd("bash ~/.config/waybar/scripts/waybar-light-controls/temperature_control.sh down"))
bind(mainMod .. " + ALT + UP", hl.dsp.exec_cmd("bash ~/.config/waybar/scripts/waybar-light-controls/light_control.sh up"))
bind(mainMod .. " + ALT + DOWN", hl.dsp.exec_cmd("bash ~/.config/waybar/scripts/waybar-light-controls/light_control.sh down"))

bind("Print", hl.dsp.exec_cmd([[grim ~/Pictures/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png && notify-send "Screenshot saved" "Saved to ~/Pictures"]]))
bind("CTRL + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" ~/Pictures/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png && notify-send "Screenshot saved" "Area captured and saved to ~/Pictures"]]))
bind("ALT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f - && notify-send "Screenshot edited" "Opened in Swappy"]]))

bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true, repeating = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
