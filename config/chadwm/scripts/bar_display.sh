#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/catppuccin

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^  CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

mem() {
  free_mem=$(free -h | awk '/^Mem/ { print $3 }' | sed s/Gi//g)
  total_mem=$(free -h | awk '/^Mem/ { print $2 }' | sed s/Gi//g)

  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $free_mem/$total_mem GiB"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨  ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭  ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^^b$blue^ $(date '+%m/%d (%A) %T') "
}

sleep 1 && xsetroot -name "$(cpu) $(mem) $(wlan) $(clock)^c$blue^^b$black^ "
