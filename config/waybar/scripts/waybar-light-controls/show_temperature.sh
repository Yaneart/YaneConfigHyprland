#!/bin/bash

CONFIG="$HOME/.config/waybar/scripts/waybar-light-controls/default_values/default_temperature.conf"

if [ -f "$CONFIG" ]; then
  temperature=$(<"$CONFIG")
  printf '%sK\n' "$temperature"
fi
