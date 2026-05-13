#!/bin/bash
# Get CPU usage percentage
prev_idle=$(awk '/^cpu / {print $5}' /proc/stat)
prev_total=$(awk '/^cpu / {print $2+$3+$4+$5}' /proc/stat)
sleep 1
curr_idle=$(awk '/^cpu / {print $5}' /proc/stat)
curr_total=$(awk '/^cpu / {print $2+$3+$4+$5}' /proc/stat)

diff_idle=$((curr_idle - prev_idle))
diff_total=$((curr_total - prev_total))
usage=$((100 * (diff_total - diff_idle) / diff_total))

# Get CPU temperature
temp=$(sensors | awk '/temp1:/{print $2;exit}')

echo "CPU $usage% | $temp"
