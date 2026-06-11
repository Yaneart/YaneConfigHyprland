# YaneConfigHyprland

**English** | [Русский](README.ru.md)

My complete desktop environment config: **Arch Linux + Hyprland** with dynamic theming —
changing the wallpaper automatically recolors the **entire** environment (Waybar, Kitty, Rofi, SwayNC, GTK, Spotify, btop, the shell prompt, and more).

![Desktop](screenshots/desktop.png)

Same setup, different wallpapers — everything recolors automatically:

| ![Green theme](screenshots/theme-green.png) | ![Orange theme](screenshots/theme-orange.png) |
|---|---|

<details>
<summary>More screenshots</summary>

**Rofi launcher** (`Super+Space`)
![Rofi launcher](screenshots/rofi.png)

**Lock screen** (Hyprlock, `Super+L`)
![Lockscreen](screenshots/lockscreen.png)

**SwayNC control center**
![SwayNC](screenshots/swaync.png)

**Wallpaper picker** (`Super+W`) — changes the colors of everything
![Wallpaper picker](screenshots/wallpaper-picker.png)

**Waybar style menu** (`Super+Shift+W`)
![Waybar styles](screenshots/waybar-styles.png)

**Power menu** (`Super+Shift+M`)
![Power menu](screenshots/powermenu.png)

**Yazi file manager**
![Yazi](screenshots/yazi.png)

**Clean desktop**
![Clean desktop](screenshots/desktop-clean.png)

</details>

## Stack

| Component | Program |
|---|---|
| Window manager | [Hyprland](https://hyprland.org/) 0.55+ (**Lua** config) |
| Bar | Waybar ([waybar-cava](https://aur.archlinux.org/packages/waybar-cava) — with built-in cava) |
| Terminal | Kitty + Starship + Fastfetch |
| Launcher / menus | Rofi (launcher, power menu, wallpaper picker, emoji) |
| Notifications | SwayNC |
| Lock screen | Hyprlock + Hypridle |
| Night light | Hyprsunset |
| Wallpapers | awww (smooth transitions) + Waypaper |
| Colors from wallpaper | **Matugen + Wallust + Pywal** — three generators chained together |
| Audio visualizer | Cava (in the terminal and in Waybar) |
| Widgets | Eww |
| Spotify | spotify-launcher + Spicetify (matugen-driven theme) |
| Login screen | SDDM + winter theme (video background) |
| File managers | Thunar, Yazi |
| Monitoring | btop (themed too) |

## How the theming works

```
Super+W (pick wallpaper) or Super+Alt+W (random)
        │
        ▼
theme-apply <wallpaper>
        │
        ├── awww img …          → smooth wallpaper transition
        ├── matugen image …     → Material You palette:
        │     waybar/colors.css, kitty, rofi, swaync, gtk, btop,
        │     cava, eww, starship, spicetify, hyprland (Lua)
        ├── wallust run …       → second palette:
        │     waybar/colors-waybar.css, kitty, rofi, vscode, zen
        ├── wal -i …            → pywal cache (for compatibility)
        │
        ├── rebuild waybar/style.css (colors + selected style preset)
        ├── hyprctl reload, restart waybar/swaync
        └── wallpaper copy → hyprlock background
```

Waybar style presets switch independently of colors: `Super+Shift+W` opens a menu
of presets (`flat-minimal`, `glass`, `neon-glow`, `solid-bold`, `mainStyle`) and bar configs.

## Installation

> Targets a clean Arch Linux. The script **backs up** existing configs to
> `~/.config-backup-<date>` before replacing anything.

```bash
git clone https://github.com/Yaneart/YaneConfigHyprland.git
cd YaneConfigHyprland
./install.sh
```

The script asks for confirmation at every step:
1. Packages from the official repos (`packages-pacman.txt`)
2. AUR packages via yay (`packages-aur.txt`) — installs yay itself if missing
3. Backup and copy of configs into `~/.config`, scripts into `~/.local/bin`, wallpapers
4. Hardcoded path replacement (`/home/yaneart` → your `$HOME`)
5. Starship hook in `~/.bashrc`
6. SDDM login theme
7. Services (NetworkManager, bluetooth, SDDM)
8. Spicetify (optional)
9. Applying the theme

After installation, log into the **Hyprland** session via SDDM.

### Manual installation

```bash
cp -a config/* ~/.config/
cp -a bin/* ~/.local/bin/ && chmod +x ~/.local/bin/*
cp -a wallpapers ~/.config/wallpapers
# replace hardcoded paths:
grep -rl '/home/yaneart' ~/.config/{hypr,waybar,waypaper} | xargs sed -i "s|/home/yaneart|$HOME|g"
echo 'eval "$(starship init bash)"' >> ~/.bashrc
~/.local/bin/theme-apply ~/.config/wallpapers/arch-blue-waves.png
```

## Good to know (quirks)

- **Hardware.** Made for a ThinkPad T480 (1920×1080, Intel graphics). On other resolutions
  Hyprland adapts by itself; monitor settings live in `config/hypr/modules/monitors.lua`.
  On NVIDIA you may need extra env variables (the usual Hyprland story) —
  `WLR_NO_HARDWARE_CURSORS=1` is already set.
- **Keyboard layout** is hardcoded to `us,ru` with Alt+Shift toggle —
  change one line in `config/hypr/modules/input.lua` if you need something else.
- **Bash only.** Starship is hooked into `~/.bashrc`; if you use zsh/fish, add
  the equivalent init line yourself. Everything else works regardless of shell.
- **Package conflicts** are normal: `waybar-cava` replaces plain `waybar`,
  `pipewire-pulse` replaces `pulseaudio` — answer "yes" when pacman asks.
- **Spotify** must be launched at least once before configuring Spicetify
  (the installer detects this and tells you).
- **Hyprland 0.55+ is required** — the config is Lua (`hyprland.lua` + modules),
  the legacy `.conf` format is not used. `hyprctl dispatch` uses Lua syntax as well.

## Repository layout

```
config/          configs for ~/.config (hypr, waybar, kitty, cava, rofi, swaync,
                 matugen, wallust, eww, spicetify, fastfetch, btop, gtk, qt, …)
bin/             scripts for ~/.local/bin (theme-apply, waybar-set, wallset, …)
sddm/            login screen theme (winter, video background) + /etc/sddm.conf.d config
wallpapers/      wallpaper collection (31)
docs/            FULL-GUIDE.en.txt / FULL-GUIDE.ru.txt — in-depth documentation
packages-*.txt   package lists (pacman / AUR)
install.sh       installer
```

## Scripts (`bin/`)

| Script | What it does |
|---|---|
| `theme-apply <img>` | wallpaper + full color regeneration for everything |
| `theme-random` | random wallpaper + theme |
| `theme-restore` | restore the last theme (runs on autostart) |
| `wallset` | Rofi wallpaper picker with previews |
| `waybar-set` / `waybar-menu` | switch Waybar styles and configs |
| `colorscheme-set` | regenerate colors without changing the wallpaper |
| `launcher` | Rofi launcher |
| `close-window` / `close_all_windows` | graceful window closing (SIGTERM follow-up) |
| `kitty-dashboard` | Kitty with the fastfetch dashboard |
| `toggle-hyprsunset` | night light on/off |
| `pywal_cava` | pywal colors for cava |

## Keybindings (essentials)

| Keys | Action |
|---|---|
| `Super + Enter` | Kitty terminal |
| `Super + Space` | launcher (Rofi) |
| `Super + Q` | close window |
| `Super + W` | wallpaper picker (changes the theme) |
| `Super + Alt + W` | random wallpaper + theme |
| `Super + Shift + W` | Waybar style menu |
| `Super + Shift + C` | regenerate colors |
| `Super + L` | lock screen (hyprlock) |
| `Super + S` | night light (hyprsunset) |
| `Super + B / C / V / E` | Firefox / Telegram / VS Code / Thunar |
| `Super + Shift + M` | power menu |
| `Super + 1–0` | workspaces |
| `Print` / `Ctrl+Print` / `Alt+Print` | screenshot: screen / area / area→Swappy |

Full list — [docs/FULL-GUIDE.en.txt](docs/FULL-GUIDE.en.txt) (section 13).

## Documentation

A detailed description of every component, every script, and the whole theming chain —
[docs/FULL-GUIDE.en.txt](docs/FULL-GUIDE.en.txt) ([русская версия](docs/FULL-GUIDE.ru.txt)).
