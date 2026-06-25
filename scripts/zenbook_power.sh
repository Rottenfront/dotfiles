#!/bin/bash

if [ "$hostname" = "zenbook" ]; then

MODE=$1

back_freq() {
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        MAX_LIMIT=$(cat "$cpu/cpufreq/cpuinfo_max_freq")
        echo "$MAX_LIMIT" | pkexec /usr/bin/tee "$cpu/cpufreq/scaling_max_freq" > /dev/null
    done
}

if [ "$MODE" = "low" ]; then
    back_freq

    echo "power" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

    # Enforce strict hardware 10W limit
    pkexec /usr/bin/ryzenadj --stapm-limit=10000 --fast-limit=10000 --slow-limit=10000

    notify-send "Power Profile" "10W power mode"

elif [ "$MODE" = "high" ]; then
    back_freq

    # Return to Balanced/Performance hardware bias
    echo "balance_performance" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    # Restore the default Zenbook 28W limits
    pkexec /usr/bin/ryzenadj --stapm-limit=28000 --fast-limit=35000 --slow-limit=28000
    notify-send "Power Profile" "28W performance Mode"

elif [ "$MODE" = "notes" ]; then
    # Force the hardware EPP to maximum power savings
    echo "power" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

    # Cap the clock frequency
    echo "1200000" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq

    # Apply the ultra-low 5W limits to RyzenAdj
    pkexec /usr/bin/ryzenadj --stapm-limit=5000 --fast-limit=6000 --slow-limit=5000 --power-saving
    
    notify-send "Power Profile" "5W 1.2GHz power mode"
else
    echo "Usage: $0 {notes|low|high}"
fi

fi
