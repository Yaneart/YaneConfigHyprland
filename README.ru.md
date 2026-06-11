# YaneConfigHyprland

[English](README.md) | **Русский**

Мой полный конфиг рабочего окружения: **Arch Linux + Hyprland** с динамической темизацией —
смена обоев автоматически перекрашивает **всё** окружение (Waybar, Kitty, Rofi, SwayNC, GTK, Spotify, btop, промпт в терминале и т.д.).

![Desktop](screenshots/desktop.png)

Тот же сетап, другие обои — всё перекрашивается автоматически:

| ![Green theme](screenshots/theme-green.png) | ![Orange theme](screenshots/theme-orange.png) |
|---|---|

<details>
<summary>Больше скриншотов</summary>

**Rofi launcher** (`Super+Space`)
![Rofi launcher](screenshots/rofi.png)

**Экран блокировки** (Hyprlock, `Super+L`)
![Lockscreen](screenshots/lockscreen.png)

**Центр уведомлений SwayNC**
![SwayNC](screenshots/swaync.png)

**Выбор обоев** (`Super+W`) — перекрашивает всё окружение
![Wallpaper picker](screenshots/wallpaper-picker.png)

**Меню стилей Waybar** (`Super+Shift+W`)
![Waybar styles](screenshots/waybar-styles.png)

**Меню питания** (`Super+Shift+M`)
![Power menu](screenshots/powermenu.png)

**Файловый менеджер Yazi**
![Yazi](screenshots/yazi.png)

**Чистый рабочий стол**
![Clean desktop](screenshots/desktop-clean.png)

</details>

## Стек

| Компонент | Программа |
|---|---|
| Оконный менеджер | [Hyprland](https://hyprland.org/) 0.55+ (конфиг на **Lua**) |
| Панель | Waybar ([waybar-cava](https://aur.archlinux.org/packages/waybar-cava) — со встроенной cava) |
| Терминал | Kitty + Starship + Fastfetch |
| Launcher / меню | Rofi (launcher, power menu, выбор обоев, эмодзи) |
| Уведомления | SwayNC |
| Блокировка | Hyprlock + Hypridle |
| Ночной режим | Hyprsunset |
| Обои | awww (плавная смена) + Waypaper |
| Цвета из обоев | **Matugen + Wallust + Pywal** — три генератора в одной цепочке |
| Аудио-визуализатор | Cava (в терминале и в Waybar) |
| Виджеты | Eww |
| Spotify | spotify-launcher + Spicetify (тема из matugen) |
| Экран входа | SDDM + тема winter (видео-фон) |
| Файловые менеджеры | Thunar, Yazi |
| Мониторинг | btop (тоже темизирован) |

## Как работает темизация

```
Super+W (выбор обоев) или Super+Alt+W (случайные)
        │
        ▼
theme-apply <обои>
        │
        ├── awww img …          → плавная смена обоев
        ├── matugen image …     → Material You палитра:
        │     waybar/colors.css, kitty, rofi, swaync, gtk, btop,
        │     cava, eww, starship, spicetify, hyprland (Lua)
        ├── wallust run …       → вторая палитра:
        │     waybar/colors-waybar.css, kitty, rofi, vscode, zen
        ├── wal -i …            → pywal-кэш (для совместимости)
        │
        ├── пересборка waybar/style.css (цвета + выбранный стиль)
        ├── hyprctl reload, перезапуск waybar/swaync
        └── копия обоев → фон hyprlock
```

Стили Waybar переключаются отдельно от цветов: `Super+Shift+W` — меню пресетов
(`flat-minimal`, `glass`, `neon-glow`, `solid-bold`, `mainStyle`) и конфигов панели.

## Установка

> Рассчитано на чистый Arch Linux. Скрипт **бэкапит** существующие конфиги в
> `~/.config-backup-<дата>` перед заменой.

```bash
git clone https://github.com/Yaneart/YaneConfigHyprland.git
cd YaneConfigHyprland
./install.sh
```

Скрипт спросит подтверждение на каждый шаг:
1. Пакеты из официальных репозиториев (`packages-pacman.txt`)
2. Пакеты из AUR через yay (`packages-aur.txt`) — поставит yay, если его нет
3. Бэкап и копирование конфигов в `~/.config`, скриптов в `~/.local/bin`, обоев
4. Замена захардкоженных путей (`/home/yaneart` → твой `$HOME`)
5. Подключение starship в `~/.bashrc`
6. Тема SDDM
7. Сервисы (NetworkManager, bluetooth, SDDM)
8. Spicetify (опционально)
9. Применение темы

После установки — войти в сессию **Hyprland** через SDDM.

### Ручная установка

```bash
cp -a config/* ~/.config/
cp -a bin/* ~/.local/bin/ && chmod +x ~/.local/bin/*
cp -a wallpapers ~/.config/wallpapers
# заменить захардкоженные пути:
grep -rl '/home/yaneart' ~/.config/{hypr,waybar,waypaper} | xargs sed -i "s|/home/yaneart|$HOME|g"
echo 'eval "$(starship init bash)"' >> ~/.bashrc
~/.local/bin/theme-apply ~/.config/wallpapers/arch-blue-waves.png
```

## Тонкости

- **Железо.** Делалось под ThinkPad T480 (1920×1080, графика Intel). На других разрешениях
  Hyprland подстроится сам; настройки мониторов — в `config/hypr/modules/monitors.lua`.
  На NVIDIA могут понадобиться дополнительные env-переменные (классика Hyprland) —
  `WLR_NO_HARDWARE_CURSORS=1` уже стоит.
- **Раскладка клавиатуры** захардкожена: `us,ru`, переключение Alt+Shift —
  меняется одной строчкой в `config/hypr/modules/input.lua`.
- **Только bash.** Starship подключается в `~/.bashrc`; для zsh/fish добавь
  соответствующую init-строку сам. Всё остальное от шелла не зависит.
- **Конфликты пакетов** — это нормально: `waybar-cava` заменяет обычный `waybar`,
  `pipewire-pulse` заменяет `pulseaudio` — отвечай «да», когда pacman спросит.
- **Spotify** надо запустить хотя бы раз до настройки Spicetify
  (установщик это понимает и подскажет).
- **Hyprland 0.55+ обязателен** — конфиг на Lua (`hyprland.lua` + модули),
  старый `.conf`-формат не используется. `hyprctl dispatch` тоже Lua-синтаксис.

## Структура репозитория

```
config/          конфиги для ~/.config (hypr, waybar, kitty, cava, rofi, swaync,
                 matugen, wallust, eww, spicetify, fastfetch, btop, gtk, qt, …)
bin/             скрипты для ~/.local/bin (theme-apply, waybar-set, wallset, …)
sddm/            тема экрана входа (winter, видео-фон) + конфиг для /etc/sddm.conf.d
wallpapers/      коллекция обоев (31 шт.)
docs/            FULL-GUIDE.ru.txt / FULL-GUIDE.en.txt — подробная документация
packages-*.txt   списки пакетов (pacman / AUR)
install.sh       установщик
```

## Скрипты (`bin/`)

| Скрипт | Что делает |
|---|---|
| `theme-apply <img>` | обои + полная регенерация цветов всего окружения |
| `theme-random` | случайные обои + тема |
| `theme-restore` | восстановить последнюю тему (вызывается в автостарте) |
| `wallset` | Rofi-меню выбора обоев с превью |
| `waybar-set` / `waybar-menu` | переключение стилей и конфигов Waybar |
| `colorscheme-set` | регенерация цветов без смены обоев |
| `launcher` | Rofi launcher |
| `close-window` / `close_all_windows` | мягкое закрытие окон (SIGTERM-добивание) |
| `kitty-dashboard` | Kitty с fastfetch-дашбордом |
| `toggle-hyprsunset` | ночной режим вкл/выкл |
| `pywal_cava` | цвета pywal для cava |

## Горячие клавиши (основные)

| Клавиши | Действие |
|---|---|
| `Super + Enter` | терминал Kitty |
| `Super + Space` | launcher (Rofi) |
| `Super + Q` | закрыть окно |
| `Super + W` | выбор обоев (меняет тему) |
| `Super + Alt + W` | случайные обои + тема |
| `Super + Shift + W` | меню стилей Waybar |
| `Super + Shift + C` | перегенерировать цвета |
| `Super + L` | блокировка (hyprlock) |
| `Super + S` | ночной режим (hyprsunset) |
| `Super + B / C / V / E` | Firefox / Telegram / VS Code / Thunar |
| `Super + Shift + M` | меню питания |
| `Super + 1–0` | воркспейсы |
| `Print` / `Ctrl+Print` / `Alt+Print` | скриншот: экран / область / область→Swappy |

Полный список — в [docs/FULL-GUIDE.ru.txt](docs/FULL-GUIDE.ru.txt) (раздел 13).

## Документация

Подробное описание каждого компонента, всех скриптов и всей цепочки темизации —
[docs/FULL-GUIDE.ru.txt](docs/FULL-GUIDE.ru.txt) ([english version](docs/FULL-GUIDE.en.txt)).
