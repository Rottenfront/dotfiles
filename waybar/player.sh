#!/bin/bash

PREFIX_PLAY=' '
PREFIX_PAUSE=' '

get_mpd() {
	status="$(playerctl status)"
	title="$(playerctl metadata title)"
	artist="$(playerctl metadata artist)"
	if [[ "$artist" = "" ]]; then
		title="$title"
	else
		title="$artist - $title"
	fi
	if [[ "$status" = "Paused" ]]; then
		title="$PREFIX_PAUSE $title"
	elif [[ "$status" = "Playing" ]]; then
		title="$PREFIX_PLAY $title"
	else
		title=""
	fi

	echo " ${title/&/&amp;} "
}

get_mpd
