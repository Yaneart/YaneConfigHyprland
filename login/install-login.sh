#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
# install-login.sh — бесшовный вход без SDDM: Plymouth + автологин + hyprlock
# Часть YaneConfigHyprland, но ОТДЕЛЬНЫЙ опт-ин установщик: он трогает ЗАГРУЗКУ
# (cmdline, UKI, mkinitcpio, bootloader, systemd), поэтому НЕ вызывается из
# главного install.sh и не должен запускаться вслепую.
#
# Схема: firmware → меню sd-boot (3с) → статичный yaneart-лого (UKI .splash) →
#        yaneart-сплэш+спиннер (Plymouth) → hyprlock → десктоп.
#
# ⚠️ ТРЕБОВАНИЯ (иначе можно не загрузиться — скрипт проверяет и предупреждает):
#   • Arch с UKI-схемой:   /boot/EFI/Linux/arch-linux.efi  +  mkinitcpio preset
#   • Intel GPU (i915).    На другом GPU убрать i915/fastboot из cmdline-флагов.
#   • systemd-boot, hyprland (uwsm), hyprlock, plymouth.
#   • Раскладка /etc/kernel/cmdline (cmdline вшит в UKI отдельным файлом).
#
# Использование:  ./install-login.sh [--yes]
#   --yes   не спрашивать подтверждений (для своей машины; на чужой НЕ надо)
#
# Откат описан в README.md этой папки.
# ──────────────────────────────────────────────────────────────────────────
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSUME_YES=0
[[ "${1:-}" == "--yes" ]] && ASSUME_YES=1

# sudo без TTY, если настроен askpass (см. основной репо); иначе обычный sudo.
SUDO="sudo"; [[ -n "${SUDO_ASKPASS:-}" ]] && SUDO="sudo -A"

c_ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }
c_info() { printf '\033[36m•\033[0m %s\n' "$*"; }
c_warn() { printf '\033[33m!\033[0m %s\n' "$*"; }
c_err()  { printf '\033[31m✗\033[0m %s\n' "$*" >&2; }

ask() { # ask "Текст?" → 0 если да
  (( ASSUME_YES )) && return 0
  local r; read -rp "$(printf '\033[33m?\033[0m %s [y/N] ' "$1")" r
  [[ "$r" == [yY] ]]
}

# ── 0. Preflight ──────────────────────────────────────────────────────────
echo "=== Проверка окружения ==="
WARN=0
[[ -f /boot/EFI/Linux/arch-linux.efi ]] && c_ok "UKI найден" \
  || { c_warn "UKI /boot/EFI/Linux/arch-linux.efi НЕ найден — схема загрузки другая"; WARN=1; }
[[ -f /etc/kernel/cmdline ]] && c_ok "/etc/kernel/cmdline есть" \
  || { c_warn "/etc/kernel/cmdline нет — cmdline задаётся иначе"; WARN=1; }
lspci -nn 2>/dev/null | grep -qiE '8086:.*\[(UHD|HD) Graphics' && c_ok "Intel GPU (i915)" \
  || { c_warn "Intel GPU не обнаружен — i915/fastboot в cmdline могут не подойти"; WARN=1; }
for b in plymouth hyprlock uwsm mkinitcpio; do
  command -v "$b" >/dev/null && c_ok "$b" || { c_warn "$b НЕ установлен"; WARN=1; }
done
(( WARN )) && { c_warn "Есть предупреждения выше."; ask "Всё равно продолжить?" || exit 1; }

# ── 1. Plymouth-тема yaneart ──────────────────────────────────────────────
if ask "Установить Plymouth-тему 'yaneart' в /usr/share/plymouth/themes/?"; then
  $SUDO mkdir -p /usr/share/plymouth/themes/yaneart
  $SUDO cp -f "$HERE"/plymouth-theme-yaneart/* /usr/share/plymouth/themes/yaneart/
  $SUDO plymouth-set-default-theme yaneart
  c_ok "Тема yaneart установлена и выбрана по умолчанию"
fi

# ── 2. mkinitcpio: hook plymouth (после kms) + ранний i915 ────────────────
if ask "Поправить /etc/mkinitcpio.conf (hook plymouth после kms, MODULES=i915)?"; then
  $SUDO cp -n /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak-prelogin || true
  # ранний KMS Intel
  if ! grep -qE '^MODULES=\([^)]*i915' /etc/mkinitcpio.conf; then
    $SUDO sed -i -E 's/^MODULES=\((.*)\)/MODULES=(i915 \1)/; s/  *\)/)/' /etc/mkinitcpio.conf
    c_ok "MODULES += i915"
  else c_info "i915 в MODULES уже есть"; fi
  # hook plymouth сразу после kms
  if ! grep -qE '^HOOKS=\(.*plymouth' /etc/mkinitcpio.conf; then
    $SUDO sed -i -E 's/(^HOOKS=\(.*\bkms\b)/\1 plymouth/' /etc/mkinitcpio.conf
    c_ok "HOOKS += plymouth (после kms)"
  else c_info "plymouth в HOOKS уже есть"; fi
fi

# ── 3. UKI preset: статичный лого через --splash ──────────────────────────
if ask "Включить статичный yaneart-лого в UKI (linux.preset --splash)?"; then
  $SUDO cp -n /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux.preset.bak-prelogin || true
  SPLASH="/usr/share/plymouth/themes/yaneart/splash-yaneart.bmp"
  if grep -qE '^default_options=' /etc/mkinitcpio.d/linux.preset; then
    $SUDO sed -i -E "s#^default_options=.*#default_options=\"--splash $SPLASH\"#" /etc/mkinitcpio.d/linux.preset
  else
    printf 'default_options="--splash %s"\n' "$SPLASH" | $SUDO tee -a /etc/mkinitcpio.d/linux.preset >/dev/null
  fi
  c_ok "linux.preset → --splash splash-yaneart.bmp"
fi

# ── 4. kernel cmdline: логиновые флаги ────────────────────────────────────
if ask "Добавить логиновые флаги в /etc/kernel/cmdline (splash, i915.fastboot, cursor off)?"; then
  $SUDO cp -n /etc/kernel/cmdline /etc/kernel/cmdline.bak-prelogin || true
  cur="$(cat /etc/kernel/cmdline)"
  for f in $(cat "$HERE/etc/kernel-cmdline-login-flags"); do
    case " $cur " in *" $f "*) ;; *) cur="$cur $f";; esac
  done
  printf '%s\n' "$cur" | $SUDO tee /etc/kernel/cmdline >/dev/null
  c_ok "cmdline дополнен (машинно-специфичные root=/resume= НЕ тронуты)"
fi

# ── 5. systemd drop-ins: автологин + plymouth-quit retain-splash ──────────
if ask "Поставить автологин getty@tty1 + override plymouth-quit (retain-splash)?"; then
  $SUDO install -Dm644 "$HERE/etc/getty-tty1-autologin.conf" \
        /etc/systemd/system/getty@tty1.service.d/autologin.conf
  $SUDO install -Dm644 "$HERE/etc/plymouth-quit-override.conf" \
        /etc/systemd/system/plymouth-quit.service.d/override.conf
  # plymouth-quit* НИКОГДА не маскировать — должны быть static (отдают DRM Hyprland'у)
  $SUDO systemctl unmask plymouth-quit.service plymouth-quit-wait.service 2>/dev/null || true
  $SUDO systemctl daemon-reload
  c_ok "getty-автологин + plymouth-quit override установлены"
fi

# ── 6. bootloader timeout ─────────────────────────────────────────────────
if ask "Выставить timeout 3 в /boot/loader/loader.conf (видно меню, можно 'e')?"; then
  $SUDO cp -n /boot/loader/loader.conf /boot/loader/loader.conf.bak-prelogin || true
  if grep -qE '^timeout' /boot/loader/loader.conf; then
    $SUDO sed -i -E 's/^timeout.*/timeout 3/' /boot/loader/loader.conf
  else
    printf 'timeout 3\n' | $SUDO tee -a /boot/loader/loader.conf >/dev/null
  fi
  c_ok "loader.conf timeout 3"
fi

# ── 7. user-юниты: тихий stderr компоновщика + автостарт в bash_profile ───
if ask "Поставить user drop-in (тихий stderr Hyprland) и блок автостарта в ~/.bash_profile?"; then
  install -Dm644 "$HERE/user/wayland-wm-quiet-stderr.conf" \
        "$HOME/.config/systemd/user/wayland-wm@.service.d/quiet-stderr.conf"
  systemctl --user daemon-reload 2>/dev/null || true
  if ! grep -q 'uwsm start hyprland.desktop' "$HOME/.bash_profile" 2>/dev/null; then
    { echo; cat "$HERE/user/bash_profile-login-block.sh"; } >> "$HOME/.bash_profile"
    c_ok "Блок автостарта дописан в ~/.bash_profile"
  else c_info "Автостарт в ~/.bash_profile уже есть"; fi
fi

# ── 8. сервисы: SDDM off, getty@tty1 on ───────────────────────────────────
if ask "Отключить sddm и включить автологин getty@tty1?"; then
  $SUDO systemctl disable sddm 2>/dev/null || true
  $SUDO systemctl enable getty@tty1
  c_ok "sddm disabled, getty@tty1 enabled"
fi

# ── 9. пересборка UKI ─────────────────────────────────────────────────────
if ask "Пересобрать UKI сейчас (mkinitcpio -P)? Нужно для применения 2–4."; then
  $SUDO mkinitcpio -P
  c_ok "UKI пересобран"
else
  c_warn "НЕ забудь: sudo mkinitcpio -P  — иначе hook/splash/cmdline не применятся"
fi

# ── 10. ручной шаг: BootOrder ─────────────────────────────────────────────
cat <<'EOF'

────────────────────────────────────────────────────────────────────────────
ОСТАЛОСЬ ВРУЧНУЮ (машинно-специфично, скрипт НЕ трогает):

  • efibootmgr: поставить "Linux Boot Manager" первым в BootOrder, если грузит
    не его. Текущий порядок:   efibootmgr
    Пример:                    sudo efibootmgr -o 0012,000E,...   (свои номера!)

  • Отпечаток в hyprlock (если нужен) — см. fingerprint в основном репо.

ПЕРЕЗАГРУЗИСЬ для проверки. Если вход не поднялся (вечный спиннер):
  Ctrl+Alt+F2 → логин → sudo systemctl start sddm   (SDDM оставлен как страховка)
  Полный откат — в README.md этой папки.
────────────────────────────────────────────────────────────────────────────
EOF
c_ok "Готово."
