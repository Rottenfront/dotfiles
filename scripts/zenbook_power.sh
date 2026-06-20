#!/bin/bash
MODE=$1

back_freq() {
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        MAX_LIMIT=$(cat "$cpu/cpufreq/cpuinfo_max_freq")
        echo "$MAX_LIMIT" | pkexec /usr/bin/tee "$cpu/cpufreq/scaling_max_freq" > /dev/null
    done
}

if [ "$MODE" = "low" ]; then
    back_freq

    # Force Hardware EPP to absolute maximum efficiency 
    echo "power" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    # Enforce strict hardware 10W limit (Stapm, Slow, and Fast bursts)
    pkexec /usr/bin/ryzenadj --stapm-limit=10000 --fast-limit=10000 --slow-limit=10000
    notify-send "Power Profile" "Switched to 10W Eco Mode 🍃"

elif [ "$MODE" = "high" ]; then
    back_freq

    # Return to Balanced/Performance hardware bias
    echo "balance_performance" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    # Restore the default Zenbook 28W limits
    pkexec /usr/bin/ryzenadj --stapm-limit=28000 --fast-limit=35000 --slow-limit=28000
    notify-send "Power Profile" "Switched to 28W Performance Mode 🚀"

elif [ "$MODE" = "notes" ]; then
    # 1. Force the hardware EPP to maximum power savings
    echo "power" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

    # 2. CAP THE CLOCK FREQUENCY (Crucial step for 5W)
    # This prevents the CPU from aggressively scaling up voltage rails
    echo "1200000" | pkexec /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq

    # 3. Apply the ultra-low 5W limits to RyzenAdj
    pkexec /usr/bin/ryzenadj --stapm-limit=5000 --fast-limit=6000 --slow-limit=5000 --power-saving
    
    notify-send "Power Profile" "5W Note-Taking Mode Engaged 📝"
else
    echo "Usage: $0 {notes|low|high}"
fi
