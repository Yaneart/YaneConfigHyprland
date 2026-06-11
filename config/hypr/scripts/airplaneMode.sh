#!/usr/bin/env bash
# Toggle airplane mode: block/unblock all radios (wi-fi + bluetooth) via rfkill.
set -euo pipefail

if ! command -v rfkill >/dev/null 2>&1; then
    notify-send -u critical "Airplane Mode" "rfkill not found"
    exit 1
fi

# If any radio is currently unblocked, enable airplane mode (block all).
# If everything is already blocked, disable it (unblock all).
if rfkill list | grep -q "Soft blocked: no"; then
    rfkill block all
    notify-send -i airplane-mode-symbolic "Airplane Mode" "Enabled — all radios off"
else
    rfkill unblock all
    notify-send -i network-wireless-symbolic "Airplane Mode" "Disabled — radios on"
fi
