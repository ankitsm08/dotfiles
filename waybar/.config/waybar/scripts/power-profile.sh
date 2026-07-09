gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [ "$gov" = "powersave" ]; then
  echo '{ "alt": "powersave", "tooltip": "Efficiency", "class": "powersave" }'
else
  echo '{ "alt": "performance", "tooltip": "Performance", "class": "performance" }'
fi
