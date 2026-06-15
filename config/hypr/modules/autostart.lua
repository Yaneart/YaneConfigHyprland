local home = os.getenv("HOME") or "/home/yaneart"
local localBin = home .. "/.local/bin"
local hyprScripts = home .. "/.config/hypr/scripts/waybar-light-controls"

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")


  hl.exec_cmd("awww-daemon")
  hl.exec_cmd(localBin .. "/theme-restore")
  hl.exec_cmd("wl-paste --watch cliphist store")   -- история буфера обмена
  hl.exec_cmd("swaync")
  hl.exec_cmd("eww daemon")   -- демон для дашборда-попапа (клик по часам)
  hl.exec_cmd("waybar")
  hl.exec_cmd("handy --start-hidden")   -- голосовой ввод (резидент в трее)
  hl.exec_cmd("hypridle")
  hl.exec_cmd(localBin .. "/border-auto")   -- рамка активного окна только при >1 окне на workspace
  hl.exec_cmd(hyprScripts .. "/hyprsunset_init.sh")
  hl.exec_cmd("setxkbmap -option compose:ralt")
  hl.exec_cmd(localBin .. "/kitty-dashboard")
end)
