#!/usr/bin/env bash

# Import Current Theme
theme = $HOME/.config/rofi/applet.rofi

# Theme Elements
prompt='Applications'
mesg="Installed Packages : `pacman -Q | wc -l` (pacman)"

list_col='6'
list_row='1'

# CMDs (add your apps here)
term_cmd='konsole'
file_cmd='pcmanfm'
text_cmd='geany'
web_cmd='com.microsoft.Edge'
setting_cmd='nvim-qt ~/.config/i3/config'

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
option_1=""
option_2=""
option_3=""
option_4=""
option_6=""

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		${term_cmd}
	elif [[ "$1" == '--opt2' ]]; then
		${file_cmd}
	elif [[ "$1" == '--opt3' ]]; then
		${text_cmd}
	elif [[ "$1" == '--opt4' ]]; then
		${web_cmd}
	elif [[ "$1" == '--opt5' ]]; then
		${setting_cmd}
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
esac

