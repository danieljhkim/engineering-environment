#!/usr/bin/env bash
#
# deploy-config.sh — link (or copy) this repo's configs into $HOME.
#
# Linux-focused: deploys the .zprofile (zsh login) variant, NOT the macOS .zshrc.
# Machine-specific env stays out of the repo in ~/.zprofile.local, which the
# deployed ~/.zprofile sources automatically — so re-deploying never clobbers it.
#
# Usage:
#   ./deploy-config.sh              # symlink configs into place (default)
#   ./deploy-config.sh --copy       # copy files instead of symlinking
#   ./deploy-config.sh --dry-run    # print actions, change nothing
#   ./deploy-config.sh --force      # don't prompt before replacing existing files
#
# Existing targets are always backed up to <target>.bak.<timestamp> before
# being replaced (unless they're already the correct symlink).
#
set -euo pipefail

# ----------------------------------------------------------------------------
# Resolve paths (works regardless of where the script is invoked from)
# ----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ----------------------------------------------------------------------------
# What gets deployed:  "<repo-relative source>::<absolute destination>"
# Skipped on purpose:
#   configs/.zshrc           -> macOS variant; Linux uses .zprofile
#   configs/wezterm/*.lua    -> GUI app config; irrelevant on a headless server
# ----------------------------------------------------------------------------
MAPPINGS=(
  "configs/.zprofile::${HOME}/.zprofile"
  "configs/.ripgreprc::${HOME}/.ripgreprc"
  "configs/nvim/init.lua::${HOME}/.config/nvim/init.lua"
)

# ----------------------------------------------------------------------------
# Options
# ----------------------------------------------------------------------------
MODE="symlink"   # symlink | copy
DRYRUN=0
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --copy)    MODE="copy" ;;
    --dry-run) DRYRUN=1 ;;
    --force)   FORCE=1 ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

STAMP="$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
# run: execute, or just print in dry-run mode
run()  { if [[ $DRYRUN -eq 1 ]]; then printf '   (dry-run) %s\n' "$*"; else eval "$*"; fi; }

# ----------------------------------------------------------------------------
# Deploy
# ----------------------------------------------------------------------------
log "Repo:   $REPO_ROOT"
log "Mode:   $MODE${DRYRUN:+ }$( [[ $DRYRUN -eq 1 ]] && echo '(dry-run)')"
echo

for entry in "${MAPPINGS[@]}"; do
  src="$REPO_ROOT/${entry%%::*}"
  dest="${entry##*::}"

  if [[ ! -e "$src" ]]; then
    warn "skip (missing source): $src"
    continue
  fi

  # Already the correct symlink? Nothing to do.
  if [[ "$MODE" == "symlink" && -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
    log "ok (already linked): $dest"
    continue
  fi

  run "mkdir -p '$(dirname "$dest")'"

  # Back up anything already at the destination (file, dir, or stale symlink).
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ $FORCE -eq 0 && $DRYRUN -eq 0 ]]; then
      printf 'Replace %s ? backup -> %s.bak.%s  [y/N] ' "$dest" "$dest" "$STAMP"
      read -r reply
      [[ "$reply" == "y" || "$reply" == "Y" ]] || { warn "skipped: $dest"; continue; }
    fi
    run "mv '$dest' '${dest}.bak.${STAMP}'"
    log "backed up -> ${dest}.bak.${STAMP}"
  fi

  if [[ "$MODE" == "symlink" ]]; then
    run "ln -s '$src' '$dest'"
    log "linked: $dest -> $src"
  else
    run "cp -a '$src' '$dest'"
    log "copied: $src -> $dest"
  fi
done

# ----------------------------------------------------------------------------
# Reminder: machine-specific env lives outside the repo
# ----------------------------------------------------------------------------
echo
log "Done."
if [[ ! -e "${HOME}/.zprofile.local" ]]; then
  cat <<EOF

NOTE: ~/.zprofile.local does not exist. Host-specific env (PATH additions,
JAVA_HOME, orbit/dsearch, secrets) belongs there — the deployed ~/.zprofile
sources it automatically. If you just replaced an older ~/.zprofile, check its
backup (${HOME}/.zprofile.bak.${STAMP}) for any lines to move into it.
EOF
fi
