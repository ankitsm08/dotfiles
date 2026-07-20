#!/usr/bin/env bash
# bootstrap.sh — Complete Arch Linux system bootstrap
#
# Usage:  ./bootstrap.sh
# Safety: Run on a fresh Arch install as the primary user (in sudo group).
#         Idempotent — safe to re-run. Comment out any module line to skip it.
#
# Structure:
#   lib/helpers.sh      — Shared functions (parui, pacmani, has_pkg, etc.)
#   modules/NN-*.sh     — Modular, self-contained, idempotent
#
# Design principles:
#   • Only packages the user explicitly chose (pacman -Qe)
#   • --needed on every install = re-runnable without side effects
#   • Each module is choosable — comment out a single line to skip
#   • Clean, readable, consistent style

set -euo pipefail

# -- Config ----------------------------------------------------------
# Set to 1 to skip steps requiring sudo (dry-run for inspection)
SKIP_SUDO=${SKIP_SUDO:-0}

# -- Bootstrap directory ---------------------------------------------
BOOTSTRAP_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULES_DIR="$BOOTSTRAP_DIR/modules"
LIB_DIR="$BOOTSTRAP_DIR/lib"

# -- Source helpers --------------------------------------------------
source "$LIB_DIR/helpers.sh"

# -- Preamble --------------------------------------------------------
echo -e "\n${BLD}${CYN}=== Arch Linux Bootstrap ===${RST}"
echo -e "${DIM}Starting bootstrap from: $BOOTSTRAP_DIR${RST}"
echo -e "${DIM}Modules in:              $MODULES_DIR${RST}"
echo -e "${DIM}To skip a module, comment its line in bootstrap.sh${RST}"
echo ""

if [[ $SKIP_SUDO -eq 1 ]]; then
  warn "SKIP_SUDO=1 — skipping all sudo operations (dry-run inspection)"
fi

# -- Sanity checks ---------------------------------------------------
if [[ ! -d "$MODULES_DIR" ]]; then
  fail "modules directory not found at $MODULES_DIR"
  exit 1
fi

if ! command -v sudo &>/dev/null; then
  fail "sudo is required — install base first"
  exit 1
fi

# -- Module runner ---------------------------------------------------
run_module() {
  local module="$1"
  local module_path="$MODULES_DIR/$module"

  if [[ ! -f "$module_path" ]]; then
    warn "module not found: $module (skipping)"
    return 0
  fi

  log "▶ Running: $module"
  if [[ $SKIP_SUDO -eq 1 ]]; then
    # Dry-run: just show what deps it wants
    local deps
    deps=$(grep -h 'pacmani\|parui' "$module_path" 2>/dev/null || true)
    if [[ -n "$deps" ]]; then
      echo -e "  ${DIM}$(echo "$deps" | tr '\n' ' ' | sed 's/  */ /g')${RST}"
    fi
    return 0
  fi

  bash "$module_path"
  echo ""
}

# ===================================================================
# MODULES — Comment out any line to skip that module entirely
# ===================================================================

run_module "00-mirrors.sh"        # Pacman mirror selection (reflector)
run_module "01-base.sh"           # Kernel, firmware, base system, drivers
run_module "02-paru.sh"           # AUR helpers (paru, yay)
run_module "03-shell.sh"          # Zsh, terminals, tmux, prompt
run_module "04-tools.sh"          # Modern CLI tools, file management
run_module "05-dev.sh"            # Development: editors, languages, build tools
run_module "06-docker.sh"         # Docker engine and Compose
run_module "07-desktop.sh"        # Hyprland DE, theming, UI
run_module "08-apps-office.sh"    # LibreOffice, Obsidian, Thunderbird
run_module "09-apps-creative.sh"  # Blender, GIMP, Krita, Kdenlive
run_module "10-apps-media.sh"     # MPV, Spotify, audio processing
run_module "11-apps-comm.sh"      # Discord, Telegram, Signal, Element
run_module "12-apps-gaming.sh"    # Steam, Lutris, Bottles, GameScope
run_module "13-apps-misc.sh"      # Browsers, misc apps, etc.
run_module "14-fonts.sh"          # Fonts and typefaces
run_module "15-services.sh"       # Systemd service enabling
run_module "16-sysctl.sh"         # Kernel parameters
run_module "17-dotfiles.sh"       # GNU Stow dotfile deployment

# ===================================================================

echo -e "\n${BLD}${GRN}=== Bootstrap complete ===${RST}"

# -- Post-run tips ---------------------------------------------------
echo ""
echo -e "${DIM}Post-install suggestions:${RST}"
echo -e "${DIM}  * Log out and back in for group changes (docker)${RST}"
echo -e "${DIM}  * chsh -s /usr/bin/zsh        (set default shell)${RST}"
echo -e "${DIM}  * Launch Spotify once before spicetify${RST}"
echo -e "${DIM}  * spicetify apply             (apply theme)${RST}"
echo -e "${DIM}  * sudo reboot                 (apply kernel params)${RST}"
