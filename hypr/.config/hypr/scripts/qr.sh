#!/usr/bin/env bash
# set -o pipefail

# Select region, exit if cancelled
region=$(slurp -b 00000060 -c b4befe -w 1 -d) || exit
[ -z "$region" ] && exit

# Capture region and scan for QR
qr=$(grim -g "$region" -t png - \
  | zbarimg --quiet --raw - 2>/dev/null)

# If nothing found, notify and exit
if [ -z "$qr" ]; then
  notify -r 9992 -e -t 2000 -u normal -i camera-photo "QR Scanner" "No QR code found"
  exit 1
fi

# Copy to clipboard and notify success
printf "%s" "$qr" | wl-copy
notify -r 9992 -e -t 3000 -u low -i camera-photo "QR Scanner - Copied to Clipboard" "$qr"
