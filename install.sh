#!/usr/bin/env bash
# YaneConfigHyprland — установщик
# Arch Linux + Hyprland rice от yaneart
#
# Использование: ./install.sh [--yes]
#   --yes  неинтерактивный режим: «да» на все вопросы, pacman/yay с --noconfirm
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
STATE_DIR="$HOME/.local/state/theme"

NOCONFIRM=""
for arg in "$@"; do
  case "$arg" in
    --yes|-y) NOCONFIRM="--noconfirm" ;;
    *) echo "Неизвестный аргумент: $arg (доступен только --yes)" >&2; exit 1 ;;
  esac
done

# Конфиги, которые будут установлены в ~/.config
CONFIG_DIRS=(hypr waybar kitty cava rofi swaync matugen wallust wal eww
             spicetify fastfetch btop waypaper yazi nvim gtk-3.0 gtk-4.0
             qt5ct qt6ct)

msg()  { printf '\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$1"; }
ask()  { if [[ -n "$NOCONFIRM" ]]; then echo "$1 [auto-yes]"; return 0; fi
         read -rp "$1 [y/N] " a; [[ "${a,,}" == y* ]]; }

if [[ ! -f /etc/arch-release ]]; then
  echo "Этот скрипт рассчитан на Arch Linux (pacman + AUR)." >&2
  exit 1
fi

msg "YaneConfigHyprland installer"
echo "Репозиторий: $REPO_DIR"
echo "Бэкап старых конфигов: $BACKUP_DIR"
echo

# ── 1. Пакеты ────────────────────────────────────────────────────────────
# Списки читаем в массивы и передаём аргументами: если кормить pacman/yay
# через stdin, их интерактивные вопросы ("Proceed? [Y/n]") ломаются.
if ask "Установить пакеты из официальных репозиториев (pacman)?"; then
  mapfile -t pkgs < <(grep -vE '^\s*(#|$)' "$REPO_DIR/packages-pacman.txt")
  sudo pacman -S --needed $NOCONFIRM "${pkgs[@]}"
fi

if ask "Установить пакеты из AUR (через yay)?"; then
  if ! command -v yay >/dev/null; then
    msg "yay не найден — устанавливаю"
    sudo pacman -S --needed --noconfirm git base-devel
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
  fi
  mapfile -t aur_pkgs < <(grep -vE '^\s*(#|$)' "$REPO_DIR/packages-aur.txt")
  # Сборка из AUR может упасть из-за разового сетевого сбоя (crates.io и т.п.) —
  # одна автоматическая повторная попытка чинит большинство таких случаев.
  if ! yay -S --needed $NOCONFIRM "${aur_pkgs[@]}"; then
    msg "Не все AUR-пакеты установились — повторная попытка"
    if ! yay -S --needed $NOCONFIRM "${aur_pkgs[@]}"; then
      echo >&2
      echo "AUR-пакеты не установились. Это не страшно: запусти ./install.sh ещё раз —" >&2
      echo "он продолжит с места сбоя, уже установленное пропустится (--needed)." >&2
      exit 1
    fi
  fi
fi

# ── 2. Бэкап существующих конфигов ───────────────────────────────────────
msg "Бэкап существующих конфигов в $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for d in "${CONFIG_DIRS[@]}"; do
  [[ -e "$HOME/.config/$d" ]] && cp -a "$HOME/.config/$d" "$BACKUP_DIR/"
done
[[ -f "$HOME/.config/starship.toml" ]] && cp "$HOME/.config/starship.toml" "$BACKUP_DIR/"

# ── 3. Установка конфигов ────────────────────────────────────────────────
msg "Копирую конфиги в ~/.config"
mkdir -p "$HOME/.config"
for d in "${CONFIG_DIRS[@]}"; do
  rm -rf "${HOME:?}/.config/$d"
  cp -a "$REPO_DIR/config/$d" "$HOME/.config/"
done
cp "$REPO_DIR/config/starship.toml" "$HOME/.config/"

msg "Копирую скрипты в ~/.local/bin"
mkdir -p "$HOME/.local/bin"
cp -a "$REPO_DIR/bin/." "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*

msg "Копирую обои в ~/.config/wallpapers"
mkdir -p "$HOME/.config/wallpapers"
cp -a "$REPO_DIR/wallpapers/." "$HOME/.config/wallpapers/"

# ── 4. Замена захардкоженных путей ───────────────────────────────────────
msg "Подставляю \$HOME вместо /home/yaneart в конфигах"
grep -rl '/home/yaneart' "$HOME/.config"/{hypr,waybar,waypaper,matugen,spicetify} 2>/dev/null \
  | while read -r f; do sed -i "s|/home/yaneart|$HOME|g" "$f"; done

# ── 5. Начальное состояние темы ──────────────────────────────────────────
msg "Инициализирую состояние темы"
mkdir -p "$STATE_DIR"
default_wall="$HOME/.config/wallpapers/arch-blue-waves.png"
[[ -f "$default_wall" ]] || default_wall="$(find "$HOME/.config/wallpapers" -type f | head -1)"
echo "$default_wall" > "$STATE_DIR/current_wallpaper"
echo "$HOME/.config/waybar/custom styles/mainStyle.css" > "$STATE_DIR/current_waybar_style"

# ── 6. Starship: промпт в bash ───────────────────────────────────────────
if ! grep -q 'starship init bash' "$HOME/.bashrc" 2>/dev/null; then
  msg "Подключаю starship в ~/.bashrc"
  printf '\neval "$(starship init bash)"\n' >> "$HOME/.bashrc"
fi

# ── 7. SDDM: тема экрана входа ───────────────────────────────────────────
if ask "Установить тему SDDM (winter, видео-фон)?"; then
  sudo cp -a "$REPO_DIR/sddm/themes/winter" /usr/share/sddm/themes/
  sudo mkdir -p /etc/sddm.conf.d
  sudo cp "$REPO_DIR/sddm/theme.conf" /etc/sddm.conf.d/theme.conf
fi

# ── 8. Сервисы ───────────────────────────────────────────────────────────
if ask "Включить сервисы (NetworkManager, bluetooth, sddm)?"; then
  sudo systemctl enable NetworkManager bluetooth
  sudo systemctl enable sddm
fi

# Docker: демон НЕ автозапускается — docker.socket поднимает его при первом
# обращении (Super+D / lazydocker). Группа docker = работа без sudo (нужен релогин).
if command -v dockerd >/dev/null && ask "Настроить Docker (socket-активация + группа docker)?"; then
  sudo systemctl enable docker.socket
  sudo usermod -aG docker "$USER"
fi

# ── 9. Spicetify (опционально) ───────────────────────────────────────────
if command -v spicetify >/dev/null && ask "Настроить Spicetify (тема Spotify)? Spotify должен быть запущен хотя бы раз."; then
  spotify_prefs="$HOME/.config/spotify/prefs"
  if [[ -f "$spotify_prefs" ]]; then
    spicetify config spotify_path "$HOME/.local/share/spotify-launcher/install/usr/share/spotify" || true
    spicetify config prefs_path "$spotify_prefs" || true
    spicetify backup apply || true
  else
    echo "Spotify ещё не запускался — пропускаю. Позже: spicetify backup apply"
  fi
fi

# ── 10. Применить тему ────────────────────────────────────────────────────
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  msg "Применяю тему"
  "$HOME/.local/bin/theme-apply" "$default_wall" || true
else
  echo "Сейчас не Hyprland-сессия — тема применится при первом входе (theme-restore в автостарте)."
fi

echo
msg "Готово!"
echo "  • Старые конфиги: $BACKUP_DIR"
echo "  • Войди в сессию Hyprland (через SDDM) — тема подтянется автоматически."
echo "  • Смена обоев + темы: Super+W, случайная: Super+Alt+W"
echo "  • Стили Waybar: Super+Shift+W"
