#!/bin/bash

lqip-auto() {
  local input="$1"
  local min_chars="${2:-900}"
  local max_chars="${3:-1000}"

  # Dependency Check 
  for cmd in magick fd jq base64; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Missing dependency: $cmd" >&2
      return 127
    fi
  done

  if [[ -z "$input" ]]; then
    echo "Usage: lqip_auto <file|dir> [min max]" >&2
    return 1
  fi

  # Internal Processing Function 
  local process_file
  process_file() {
    local img="$1"
    
    # Debug logger
    log_debug() {
      [[ -n "$DEBUG" ]] && echo -e "\033[90m[DEBUG] $1\033[0m" >&2
    }

    # Define Stages 
    local stages=(
      "16:5" "16:10"
      "32:8" "32:12"
      "64:10" "64:15" "64:20"
      "96:10" "96:15" "96:20" "96:25" "96:30"
      "128:10" "128:15"
    )

    # Add the fine-tuning ramp for 128px (Q20 to Q50)
    for (( q=20; q<=50; q+=5 )); do
      stages+=("128:$q")
    done

    local mime="image/webp"
    local best_b64=""
    local best_len=0
    local best_size=0
    local best_q=0
    
    local curr_b64 curr_len size q

    # Loop through stages 
    for stage in "${stages[@]}"; do
      size="${stage%%:*}"
      q="${stage#*:}"

      # Generate Base64
      curr_b64=$(magick "$img" \
        -resize "${size}x${size}^" \
        -quality "$q" \
        -define webp:method=6 \
        -strip \
        webp:- | base64 -w 0)

      curr_len=${#curr_b64}

      log_debug "Trying ${size}px Q${q} \t:: Result: $curr_len chars"

      # CASE 1: Too Big (Overshoot)
      if (( curr_len > max_chars )); then
        log_debug "-> Too big (> $max_chars). Stopping and using previous best."
        break
      fi

      # CASE 2: Valid Candidate (Under Max)
      best_b64="$curr_b64"
      best_len=$curr_len
      best_size=$size
      best_q=$q

      # CASE 3: Perfect Match (Inside Range)
      if (( curr_len >= min_chars )); then
        log_debug "-> Success ($min_chars <= $curr_len <= $max_chars)"
        break
      fi
    done

    # Final Validation 
    if (( best_len == 0 )); then
      [[ -n "$DEBUG" ]] && echo "Failed: Even smallest size was too big or magick failed." >&2
      return 1
    fi

    log_debug "Final Selection: ${best_size}px Q${best_q} ($best_len chars)"

    jq -n \
      --arg file "$img" \
      --arg mime "$mime" \
      --arg b64 "$best_b64" \
      --argjson chars "$best_len" \
      --argjson shortest_side "$best_size" \
      --argjson quality "$best_q" \
      '{
        file: $file,
        mime: $mime,
        chars: $chars,
        shortest_side: $shortest_side,
        quality: $quality,
        lqip: ("data:" + $mime + ";base64," + $b64)
      }'
  }

  # Execution Logic 
  if [[ -f "$input" ]]; then
    process_file "$input" \
    | bat -pl json || {
      echo "No valid LQIP possible for $input" >&2
      return 2
    }
    return 0
  fi

  if [[ -d "$input" ]]; then
    fd \
      -e jpg -e jpeg -e png -e webp -e avif -e tif -e tiff -e bmp \
      . "$input" \
    | sort \
    | while read -r img; do
        process_file "$img" || \
          echo "Skipped $img" >&2
      done \
    | jq -s '.' \
    | bat -pl json
    return 0
  fi

  echo "Invalid path: $input" >&2
  return 1
}

# Guard Clause 
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    lqip-auto "$@"
fi
