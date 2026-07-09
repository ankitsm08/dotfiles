#!/usr/bin/env bash
# set -o pipefail

# Get region, exit if user cancels
region=$(slurp -b 00000060 -c b4befe -w 1 -d) || exit
[ -z "$region" ] && exit

# Grab screenshot, pass to tesseract, and clean up the output
text=$(grim -g "$region" -t png - \
| magick - -colorspace gray -sigmoidal-contrast 10,50% -resize 200% - \
| tesseract stdin stdout --psm 3 --oem 1 -l eng \
| tr -d '\r' \
| sed '/^$/d;
     s/^[[:space:]]*//;
     s/[[:space:]]*$//;
     s/[“”]/"/g;
     s/[‘’]/'\''/g;
     s/[—–]/-/g;
     s/…/.../g;
     s/\xC2\xA0/ /g')

# If no text is found, notify and EXIT
if [ -z "$text" ]; then
    notify-send -r 9991 -e -t 2000 -u normal -i accessories-character-map "OCR" "No Text Found"
    exit 1
fi

# Copy to clipboard and notify success
printf "%s" "$text" | wl-copy
notify-send -r 9991 -e -t 3000 -u low -i accessories-character-map "OCR" "Copied to Clipboard"
