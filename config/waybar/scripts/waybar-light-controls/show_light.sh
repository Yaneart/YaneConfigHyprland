#!/bin/bash

CONFIG="$HOME/.config/waybar/scripts/waybar-light-controls/default_values/default_light.conf"

if [ -f "$CONFIG" ]; then
  light=$(<"$CONFIG")
  printf '%s%%\n' "$light"
fi
