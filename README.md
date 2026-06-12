<div align="center">

# ❄️ YaneConfigHyprland

**Arch Linux + Hyprland** rice with full dynamic theming —
change the wallpaper and *everything* recolors itself.

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-0.55+-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white)
![Lua](https://img.shields.io/badge/config-Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)

**English** | [Русский](README.ru.md)

</div>

---

## 📸 Showcase

![Desktop](screenshots/desktop.png)

Same setup, different wallpapers — everything recolors automatically:

| ![Green theme](screenshots/theme-green.png) | ![Orange theme](screenshots/theme-orange.png) |
|---|---|

<details>
<summary><b>More screenshots</b> — Rofi, lock screen, widgets, menus…</summary>
<br>

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

**Spotify music widget** (Eww + mpris in Waybar, `Super+P`)
![Music widget](screenshots/music-widget.png)

**Yazi file manager**
![Yazi](screenshots/yazi.png)

**Clean desktop**
![Clean desktop](screenshots/desktop-clean.png)

</details>

---

## 📦 Installation

> Targets a clean Arch Linux with **Hyprland 0.55+**. The script **backs up**
> existing configs to `~/.config-backup-<date>` before replacing anything.

```bash
git clone https://github.com/Yaneart/YaneConfigHyprland.git
cd YaneConfigHyprland
./install.sh
```

The script asks for confirmation at every step (packages, configs, SDDM theme,
services, Spicetify, theme). Unattended install: `./install.sh --yes`.
After installation, log into the **Hyprland** session via SDDM.

<details>
<summary><b>Worth knowing during install</b></summary>
<br>

- **Hyprland 0.55+ is required** — the config is Lua, the legacy `.conf` format is not used.
- **Package conflicts are normal**: `waybar-cava` replaces plain `waybar`,
  `pipewire-pulse` replaces `pulseaudio` — answer "yes" when pacman asks.
- **Spotify** must be launched at least once before configuring Spicetify
  (the installer detects this and tells you).
- **Bash only**: Starship is hooked into `~/.bashrc`; for zsh/fish add the
  equivalent init line yourself. Everything else works regardless of shell.

</details>

<details>
<summary><b>Manual installation</b></summary>
<br>

```bash
cp -a config/* ~/.config/
cp -a bin/* ~/.local/bin/ && chmod +x ~/.local/bin/*
cp -a wallpapers ~/.config/wallpapers
# replace hardcoded paths:
grep -rl '/home/yaneart' ~/.config/{hypr,waybar,waypaper} | xargs sed -i "s|/home/yaneart|$HOME|g"
echo 'eval "$(starship init bash)"' >> ~/.bashrc
~/.local/bin/theme-apply ~/.config/wallpapers/arch-blue-waves.png
```

</details>

<details>
<summary><b>Hardware notes & quirks</b></summary>
<br>

- **Hardware.** Made for a ThinkPad T480 (1920×1080, Intel graphics). On other resolutions
  Hyprland adapts by itself; monitor settings live in `config/hypr/modules/monitors.lua`.
  On NVIDIA you may need extra env variables (the usual Hyprland story) —
  `WLR_NO_HARDWARE_CURSORS=1` is already set.
- **Keyboard layout** is hardcoded to `us,ru` with Alt+Shift toggle —
  change one line in `config/hypr/modules/input.lua` if you need something else.

</details>

---

## ⌨️ Keybindings

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
| `Super + P` | Spotify (Spicetify theme + Eww music widget) |
| `Super + D` | lazydocker (Docker TUI; the daemon starts on demand) |
| `Super + Shift + M` | power menu |
| `Super + 1–0` | workspaces |
| `Print` / `Ctrl+Print` / `Alt+Print` | screenshot: screen / area / area→Swappy |

---

<div align="center">

## 📖 Full guide

The stack, every component, every script, the full hotkey list
and the whole theming chain — explained in detail in
**[docs/FULL-GUIDE.en.txt](docs/FULL-GUIDE.en.txt)** ([русская версия](docs/FULL-GUIDE.ru.txt))

⭐ **Star the repo if you like the rice** ⭐

</div>
