# Hyprland Setup

This config uses `hyprland.lua` as the only Hyprland entry point.

## Main files

- `~/.config/hypr/hyprland.lua`: loads the Lua modules.
- `~/.config/hypr/modules/autostart.lua`: startup apps and theme restore.
- `~/.config/hypr/modules/bindings.lua`: keybinds.
- `~/.config/hypr/modules/layout.lua`: gaps, blur, opacity, animations.
- `~/.config/hypr/modules/input.lua`: keyboard layout and input options.
- `~/.config/hypr/modules/monitors.lua`: monitor and workspace rules.
- `~/.config/hypr/hyprlock.conf`: lock screen look.
- `~/.config/hypr/hypridle.conf`: idle timers.

## Theme pipeline

Wallpaper and colors are handled by these scripts:

- `~/.local/bin/theme-apply <file>`: set wallpaper and regenerate colors.
- `~/.local/bin/theme-apply --colors-only <file>`: regenerate colors without changing the wallpaper.
- `~/.local/bin/theme-random`: pick a random wallpaper.
- `~/.local/bin/theme-restore`: restore the last applied wallpaper and palette.

Generated colors land here:

- `~/.config/hypr/modules/generated_colors.lua`: Hyprland color source.
- `~/.config/waybar/colors.css`: Matugen colors for Waybar.
- `~/.config/waybar/colors-waybar.css`: Wallust colors for Waybar.
- `~/.config/rofi/colors/colors-matugen.rasi`
- `~/.config/rofi/colors/colors-wallust.rasi`
- `~/.cache/wallust/colors-kitty.conf`: Kitty colors.

## Day-to-day control

- `Super + W`: choose a wallpaper and apply wallpaper + colors.
- `Super + Alt + W`: random wallpaper.
- `Super + Shift + C`: regenerate colors from a chosen image without changing wallpaper.
- `Super + Shift + R`: restore the last wallpaper and palette.
- `Super + Shift + W`: choose a Waybar style or full config.
- `Super + R`: restart Waybar.
- `Super + L`: lock screen.
- `Super + Shift + M`: power menu.

## What to edit

- Change Waybar style imports in `~/.config/waybar/style.css`, or use `Super + Shift + W`.
- Put alternate Waybar configs as `*.jsonc` files in `~/.config/waybar/configs/` and pick them from `Super + Shift + W`.
- Change lock screen layout in `~/.config/hypr/hyprlock.conf`.
- Change idle timeouts in `~/.config/hypr/hypridle.conf`.
- Change keybinds in `~/.config/hypr/modules/bindings.lua`.
- Change monitor rules in `~/.config/hypr/modules/monitors.lua`.
- Change wallpaper set by default by putting files in `~/.config/wallpapers/`.

## Verify after edits

Run:

```bash
Hyprland --verify-config
```
