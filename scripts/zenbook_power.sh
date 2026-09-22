# !(env bash)

if [ "$HOSTNAME" = "aorus" ]; then

MODE=$1

back_freq() {
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        MAX_LIMIT=$(cat "$cpu/cpufreq/cpuinfo_max_freq")
        echo "$MAX_LIMIT" | sudo tee "$cpu/cpufreq/scaling_max_freq" > /dev/null
    done
}
if [ "$MODE" = "notes" ]; then
    # Force the hardware EPP to maximum power savings
    echo "power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

    # Cap the clock frequency
    echo "1200000" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq

    # Apply 5W limits
    sudo ryzenadj --stapm-limit=5000 --fast-limit=6000 --slow-limit=5000 --power-saving
    
    notify-send "Power Profile" "5W 1.2GHz power mode"

elif [ "$MODE" = "low" ]; then
    back_freq

    echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

    # Apply 10W limit
    sudo ryzenadj --stapm-limit=10000 --fast-limit=10000 --slow-limit=10000

    notify-send "Power Profile" "10W power mode"

elif [ "$MODE" = "lowperf" ]; then
    back_freq

    echo "balance_performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

    # Apply 10W limit
    sudo ryzenadj --stapm-limit=15000 --fast-limit=17000 --slow-limit=15000

    notify-send "Power Profile" "Gaming 15W power mode"


elif [ "$MODE" = "high" ]; then
    back_freq

    # Return to Balanced/Performance hardware bias
    echo "balance_performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    # Restore the default Zenbook 28W limits
    sudo ryzenadj --stapm-limit=28000 --fast-limit=35000 --slow-limit=28000
    notify-send "Power Profile" "28W performance Mode"

else
    echo "Usage: $0 {notes|low|high}"
fi

fi
