#!/bin/bash

SOUND_DIR="$HOME/music/soundboard"
mkdir -p "$SOUND_DIR"

# -- VOLUME CONTROL --
# Set closer to 0 (e.g., -10) to make the soundboard LOUDER.
# Set further from 0 (e.g., -20) to make the soundboard QUIETER.
# -14 is standard internet loudness.
VOLUME_TARGET="-14"
# --------------------


# Get the absolute path of this script so it can call itself reliably
SCRIPT_PATH=$(realpath "$0")

# Move to the directory once at the top to keep the rest of the script clean
cd "$SOUND_DIR" || exit

# MODE 1: Playback Handler (triggered by FZF Enter)
if [ "$1" = "--play" ]; then
  # TARGETED KILL: Only kills mpv instances carrying the soundboard device flag
  pkill -f "pulse/Soundboard" 2>/dev/null

  # Run mpv in background and exit this script instantly.
  # This prevents FZF's subshell from trapping and killing mpv.
  mpv --no-config \
    --no-resume-playback \
    --keep-open=no \
    --no-video \
    --ao=pulse \
    --audio-device="pulse/Soundboard" \
    --af=loudnorm=I=${VOLUME_TARGET}:TP=-2:LRA=11 \
    "$2" >/dev/null 2>&1 &
  exit 0
fi

# MODE 2: Mute Handler (triggered by FZF Space)
if [ "$1" = "--stop" ]; then
  pkill -f "pulse/Soundboard" 2>/dev/null
  exit 0
fi

# MODE 3: Preview Handler (triggered by FZF Hover)
if [ "$1" = "--preview" ]; then
  if command -v ffprobe >/dev/null 2>&1; then
    # Read ffprobe values directly into variables (safe from injection)
    sample_rate="" channels="" duration="" size="" bit_rate=""
    while IFS== read -r key value; do
      case "$key" in
        sample_rate) sample_rate="$value" ;;
        channels)    channels="$value" ;;
        duration)    duration="$value" ;;
        size)        size="$value" ;;
        bit_rate)    bit_rate="$value" ;;
      esac
    done < <(ffprobe -v error -show_entries format=duration,size,bit_rate:stream=channels,sample_rate -of default=noprint_wrappers=1 "$2" 2>/dev/null)

    # Apply defaults if anything is empty
    [ -z "$sample_rate" ] && sample_rate=0
    [ -z "$channels" ] && channels=0
    [ -z "$duration" ] && duration=0
    [ -z "$size" ] && size=0
    [ -z "$bit_rate" ] && bit_rate=0

    # Human-readable calculations
    dur_text=$(awk "BEGIN { printf \"%.2fs\", $duration }")

    case "$channels" in
      1) ch_text="Mono" ;;
      2) ch_text="Stereo" ;;
      6) ch_text="5.1 Surround" ;;
      0) ch_text="Unknown" ;;
      *) ch_text="${channels} ch" ;;
    esac

    size_text=$(awk "BEGIN { if ($size >= 1048576) printf \"%.2f MB\", $size/1048576; else printf \"%.1f KB\", $size/1024 }")
    bit_text=$(awk "BEGIN { if ($bit_rate > 0) printf \"%.0f kbps\", $bit_rate/1000; else printf \"Unknown\" }")
    sample_text=$(awk "BEGIN { if ($sample_rate > 0) printf \"%.1f kHz\", $sample_rate/1000; else printf \"Unknown\" }")

    # TrueColor ANSI Escapes matching Catppuccin Mocha
    R="\033[0m" B="\033[1m"
    MAUVE="\033[38;2;203;166;247m"
    BLUE="\033[38;2;137;180;250m"
    GREEN="\033[38;2;166;227;161m"
    PEACH="\033[38;2;250;179;135m"
    SUBTEXT="\033[38;2;166;173;200m"

    # Print the beautiful preview card
    echo -e " ${MAUVE}===${B} AUDIO METADATA ${R}${MAUVE}===${R}"
    echo -e "  ${SUBTEXT}Duration  :${R} ${BLUE}${dur_text}${R}"
    echo -e "  ${SUBTEXT}Channels  :${R} ${GREEN}${ch_text}${R}"
    echo -e "  ${SUBTEXT}File Size :${R} ${PEACH}${size_text}${R}"
    echo -e "  ${SUBTEXT}Bitrate   :${R} ${BLUE}${bit_text}${R}"
    echo -e "  ${SUBTEXT}Sample    :${R} ${GREEN}${sample_text}${R}"
  else
    # Muted fallback if ffprobe isn't installed
    echo -e "\033[1;35m=== Audio Information ===\033[0m"
    file "$2" | tr ',' '\n'
  fi
  exit 0
fi

# MODE 4: Default UI Mode (launched when the script is run normally)

# Catppuccin Mocha theme colors
CATPPUCCIN="--color=spinner:#F5E0DC,hl:#F38BA8,fg:#CDD6F4,header:#A6ADC8,info:#CBA6F7,pointer:#F5E0DC,marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8,selected-bg:#45475A,border:#6C7086,label:#CDD6F4"

# Generate files list
LIST_CMD="find . -type f | grep -E '\.(mp3|wav|ogg|flac|m4a)$' | sed 's|^\./||' | sort"

# Run FZF, pointing it to the script handlers
eval "$LIST_CMD" | fzf \
  --prompt=" 🎵 Sound ❯ " \
  --info=inline \
  --header="" \
  --border-label=" [ ENTER: Play | SPACE: Stop | CTRL+R: Reload | CTRL+E: Explorer | ESC: Quit ] " \
  --border-label-pos=bottom \
  --border=rounded \
  --height=100% \
  --layout=reverse \
  $CATPPUCCIN \
  --preview="'$SCRIPT_PATH' --preview {}" \
  --preview-window=right:35%:wrap \
  --bind="enter:execute-silent('$SCRIPT_PATH' --play {})" \
  --bind="double-click:execute-silent('$SCRIPT_PATH' --play {})" \
  --bind="space:execute-silent('$SCRIPT_PATH' --stop)" \
  --bind="ctrl-r:reload($LIST_CMD)" \
  --bind="ctrl-e:execute(yazi '$SOUND_DIR')"
