#!/usr/bin/env bash

receive_pipe="/tmp/waybar-ddc-module-rx"
step=5

ddcutil_fast() {
  # multiplier should be chosen so that it both works reliably and fast enough
  ddcutil --noverify -d 1 --sleep-multiplier .1 "$@" 2>/dev/null
}

ddcutil_slow() {
  ddcutil --maxtries 15,15,15 "$@" 2>/dev/null
}

# takes ddcutil commandline as arguments
print_brightness() {
  if brightness=$("$@" -t getvcp 10); then
    brightness=$(echo "$brightness" | cut -d ' ' -f 4)
  else
    brightness=-1
  fi
  echo '{ "percentage":' "$brightness" '}'
}

rm -rf $receive_pipe
mkfifo $receive_pipe

# in case waybar restarted the script after restarting/replugging a monitor
print_brightness ddcutil_slow

while true; do
  read -r command < $receive_pipe
  case $command in
    + | -)
      ddcutil_fast setvcp 10 $command $step
      ;;
    max)
      ddcutil_fast setvcp 10 90
      ;;
    min)
      ddcutil_fast setvcp 10 10
      ;;
  esac
  print_brightness ddcutil_fast
done
