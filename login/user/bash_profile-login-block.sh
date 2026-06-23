# --- Вставляется в конец ~/.bash_profile установщиком install-login.sh ---
# Автостарт графической сессии (Hyprland через uwsm) на первом VT — замена SDDM.
# Срабатывает только при автологине на tty1; обычные и SSH-шеллы не трогает.
if [ "$XDG_VTNR" = "1" ] && uwsm check may-start; then
    # Вывод увязываем в лог, чтобы голый VT1 не царапал удержанный plymouth-splash
    # текстом во время передачи DRM Hyprland'у (бело-зелёный код перед hyprlock).
    exec uwsm start hyprland.desktop >~/.local/share/uwsm-start.log 2>&1
fi
