#!/usr/bin/env bash

# Try argument first (non-empty)
if [[ -n "$1" ]]; then
  word="$1"
fi

# Fallback to primary selection if GRAB=1 and word empty
if [[ -z "$word" && "${GRAB:-0}" -eq 1 ]]; then
  word="$(wl-paste --primary 2>/dev/null)"
fi

# Fallback to clipboard if still empty
if [[ -z "$word" ]]; then
  word="$(wl-paste 2>/dev/null)"
fi

# Sanitize
word="$(echo "$word" \
  | tr -d '\n' \
  | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
  | tr '[:upper:]' '[:lower:]')"

# Check for empty word or special characters
[[ -z "$word" || "$word" =~ [\/] ]] && notify -u normal -t 3000 -i dialog-error "Invalid input." && exit 0

if ! query=$(curl -fsS \
    --connect-timeout 5 \
    --max-time 10 \
    "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word"
  ); then
  notify -u normal -t 5000 -i dialog-error "Dictionary API error."
  exit 1
fi

# Check for connection error (curl exit status stored in $?)
[ $? -ne 0 ] && notify -u normal -t 5000 -i dialog-error "Connection error." && exit 1

# Check for invalid word response
[[ "$query" == *"No Definitions Found"* ]] && notify -u normal -t 3000 -i dialog-error "No Definition found." && exit 0

# Show only first 3 definitions
def=$(echo "$query" | jq -r '[.[].meanings[] | {pos: .partOfSpeech, def: .definitions[].definition}] | .[:3].[] | "\n\(.pos). \(.def)"')

# Requires a notification daemon to be installed
notify -t 15000 -- "$word" "$def"

bold=$(tput bold) # Print text bold with echo, for visual clarity
normal=$(tput sgr0) # Reset text to normal
echo "${bold}Definition of $word"
echo "${normal}$def"

# Show first definition for each part of speech (thanks @morgengabe1 on youtube)
# def=$(echo "$query" | jq -r '.[0].meanings[] | "\(.partOfSpeech): \(.definitions[0].definition)\n"')

# Show all definitions
# def=$(echo "$query" | jq -r '.[].meanings[] | "\n\(.partOfSpeech). \(.definitions[].definition)"')
# def=$(grep -Po '"definition":"\K(.*?)(?=")' <<< "$query")

