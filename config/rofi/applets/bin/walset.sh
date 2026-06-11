#!/usr/bin/env bash

FILE=$1

if [ -z "$FILE" ]; then
  notify-send "No wallpaper selected"
  exit 1
fi

exec "$HOME/.local/bin/theme-apply" "$FILE"
