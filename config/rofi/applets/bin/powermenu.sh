#!/usr/bin/env bash
set -euo pipefail

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Power Menu

theme_path="$HOME/.config/rofi/powermenu.rasi"

# Theme Elements
prompt=''

list_col='2'
list_row='3'
option_1="Lock"
option_2="Logout"
option_3="Suspend"
option_4="Hibernate"
option_5="Reboot"
option_6="Shutdown"
yes='Yes'
no='No'

# Rofi CMD
rofi_cmd() {
	rofi -theme-str 'inputbar { enabled: false; }' \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
		-p "$prompt" \
		-markup-rows \
		-theme "$theme_path"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you sure?' \
		-theme "$HOME/.config/rofi/confirm.rasi"
}

logout_session() {
	if command -v uwsm >/dev/null 2>&1; then
		uwsm stop
	elif [[ -n "${XDG_SESSION_ID:-}" ]] && command -v loginctl >/dev/null 2>&1; then
		loginctl terminate-session "$XDG_SESSION_ID"
	else
		hyprctl dispatch exit
	fi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run () {	
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
        ${1} && ${2:-true} && ${3:-true}
    else
        exit
    fi	
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		hyprlock
	elif [[ "$1" == '--opt2' ]]; then
		confirm_run logout_session
	elif [[ "$1" == '--opt3' ]]; then
		confirm_run 'systemctl suspend' true true
	elif [[ "$1" == '--opt4' ]]; then
		confirm_run 'systemctl hibernate'
	elif [[ "$1" == '--opt5' ]]; then
		confirm_run 'systemctl reboot'
	elif [[ "$1" == '--opt6' ]]; then
		confirm_run 'systemctl poweroff'
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
esac
