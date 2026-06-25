local home = os.getenv("HOME") or "/home/yaneart"
local localBin = home .. "/.local/bin"
local hyprScripts = home .. "/.config/hypr/scripts/waybar-light-controls"

hl.on("hyprland.start", function()
  -- Логин-гейт: автологин (getty на tty1) пускает в систему БЕЗ пароля, поэтому
  -- сразу поднимаем hyprlock как «экран входа» (пароль/отпечаток), а следом гасим
  -- boot-сплэш Plymouth с --retain-splash — кадр бесшовно сменяется на hyprlock.
  hl.exec_cmd("hyprlock")
  hl.exec_cmd("plymouth quit --retain-splash")

  -- uwsm finalize разом экспортирует WAYLAND_DISPLAY/HYPRLAND_INSTANCE_SIGNATURE и сигналит systemd,
  -- иначе wayland-session-waitenv висит ~5с в ожидании HYPRLAND_INSTANCE_SIGNATURE (чёрный экран при входе).
  -- Фолбэк на ручной экспорт, если сессия запущена без uwsm.
  hl.exec_cmd("/bin/sh -c 'if command -v uwsm >/dev/null && [ -n \"$UWSM_WAIT_VARNAMES\" ]; then uwsm finalize WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE; else dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland; systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE; fi'")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")


  -- awww-daemon + установку обоев ведёт theme-restore (поднимает демон, если
  -- не запущен, и ждёт его сокет). Отдельный запуск awww-daemon убран, чтобы
  -- два демона не стартовали наперегонки.
  hl.exec_cmd(localBin .. "/theme-restore")
  hl.exec_cmd("wl-paste --watch cliphist store")   -- история буфера обмена
  hl.exec_cmd("swaync")
  hl.exec_cmd("eww daemon")   -- демон для дашборда-попапа (клик по часам)
  hl.exec_cmd("waybar")
  hl.exec_cmd("handy --start-hidden")   -- голосовой ввод (резидент в трее)
  hl.exec_cmd("hypridle")
  hl.exec_cmd("thunar --daemon")   -- резидентный файл-менеджер → окна (Super+E) открываются мгновенно
  hl.exec_cmd(localBin .. "/battery-monitor")   -- уведомления о низком заряде (20/15/10/5%), без гибернации
  hl.exec_cmd("udiskie --no-tray")   -- авто-монтирование USB-накопителей (без трей-иконки — аплеты убраны)
  hl.exec_cmd(localBin .. "/lang-osd")   -- OSD раскладки (EN/RU) по центру при переключении языка
  hl.exec_cmd(localBin .. "/border-auto")   -- рамка активного окна только при >1 окне на workspace
  hl.exec_cmd(hyprScripts .. "/hyprsunset_init.sh")
  hl.exec_cmd("setxkbmap -option compose:ralt")
  hl.exec_cmd(localBin .. "/kitty-dashboard")
end)
