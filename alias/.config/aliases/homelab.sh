#!/bin/bash
export FJ_FALLBACK_HOST="https://fj.anklab.mywire.org"

alias forgejo-completions="source <(fj completion zsh)"

anklabchown() {
  local targets=("$@")
  if [ ${#targets[@]} -eq 0 ]; then
    targets=("$HOME/homelab")
  fi

  echo "Changing ownership to ank:ank for: ${targets[*]}"
  sudo chown -R ank:ank "${targets[@]}"
}

anklabchmod() {
  local targets=("$@")
  if [ ${#targets[@]} -eq 0 ]; then
    targets=("$HOME/homelab")
  fi

  for base in "${targets[@]}"; do
    if [ ! -d "$base" ]; then
      echo "WARNING: '$base' is not a directory, skipping..." >&2
      continue
    fi

    echo "Fixing permissions in: $base"

    # 1. Directories -> 755
    echo "  Setting directories to 755..."
    fd . "$base" --no-ignore --type d --exec chmod 755 {} \; 2>/dev/null || true

    # 2. All files -> 644
    echo "  Setting files to 644..."
    fd . "$base" --no-ignore --type f --exec chmod 644 {} \; 2>/dev/null || true

    # 3. Shell scripts -> 755
    echo "  Setting shell scripts to 755..."
    fd -e sh "$base" --no-ignore --type f --exec chmod 755 {} \; 2>/dev/null || true

    # 4. Files with shebang -> 755
    echo "  Setting executable files (with shebang) to 755..."
    fd . "$base" --no-ignore --type f -x bash -c '
      for f; do
        if [[ -f "$f" && -r "$f" ]]; then
          # Read just the first 2 characters to check for shebang
          if [[ "$(head -c 2 "$f" 2>/dev/null)" == "#!" ]]; then
            chmod 755 "$f"
          fi
        fi
      done
    ' bash {} + 2>/dev/null || true

    # 5. acme.json -> 600
    echo "  Setting acme.json files to 600..."
    fd 'acme\.json$' "$base" --no-ignore --type f --exec chmod 600 {} \; 2>/dev/null || true
  done
}

anklabfix() {
  echo "Starting Anklab permission fixes..."
  anklabchown "$@"
  anklabchmod "$@"
  echo "Permission fixes completed!"
}
