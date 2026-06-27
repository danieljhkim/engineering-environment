#!/usr/bin/env bash
#
# install-linux.sh — Linux equivalent of installs/Brewfile
#
# Scope: core / CLI / shell / system tooling only.
# Intentionally omits the Brewfile's GUI/Apps, AI, language (Python/Java/Go),
# data-engineering, and font sections.
#
# Target: Debian/Ubuntu (apt). Tested on Ubuntu 24.04 LTS.
# Idempotent: safe to re-run; skips anything already installed.
#
# Usage:
#   ./install-linux.sh           # install everything in scope
#   SKIP_DOCKER=1 ./install-linux.sh
#
set -euo pipefail

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

if [[ "$(uname -s)" != "Linux" ]]; then
  warn "This script targets Linux. For macOS use the Brewfile: brew bundle --file=installs/Brewfile"
  exit 1
fi
if ! have apt-get; then
  warn "No apt-get found. This script targets Debian/Ubuntu. Adapt package names for your distro."
  exit 1
fi

SUDO=""
if [[ "$(id -u)" -ne 0 ]]; then SUDO="sudo"; fi

LOCAL_BIN="${HOME}/.local/bin"
mkdir -p "$LOCAL_BIN"

# Arch naming differs per project; resolve the common variants once.
case "$(uname -m)" in
  x86_64)        GOARCH=amd64; ALT=x86_64 ;;
  aarch64|arm64) GOARCH=arm64; ALT=arm64  ;;
  *) warn "Unsupported arch $(uname -m); binary installs may fail."; GOARCH=amd64; ALT=x86_64 ;;
esac
UNAME_M="$(uname -m)"   # buf uses x86_64 / aarch64 verbatim

# Latest release tag (e.g. v0.42.0) for a GitHub repo.
latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -oP '"tag_name":\s*"\K[^"]+'
}

# Download a single-file binary to ~/.local/bin and chmod +x.
install_bin() {  # <url> <dest-name>
  local url="$1" name="$2"
  log "Installing ${name} -> ${LOCAL_BIN}/${name}"
  curl -fsSL "$url" -o "${LOCAL_BIN}/${name}"
  chmod +x "${LOCAL_BIN}/${name}"
}

# ----------------------------------------------------------------------------
# APT packages  (Core CLI + Shell + grpc + Containers + Monitoring + Editor)
# ----------------------------------------------------------------------------
# Mapping notes vs Brewfile:
#   coreutils      -> GNU coreutils (preinstalled on Linux; listed for parity)
#   watch          -> provided by `procps`
#   fd             -> `fd-find`  (binary is `fdfind`; symlinked to fd below)
#   bat            -> `bat`      (binary is `batcat`; symlinked to bat below)
#   protobuf       -> `protobuf-compiler` (protoc)
#   docker         -> `docker.io` engine (no Docker Desktop on a server)
APT_PKGS=(
  # Core CLI
  git gh curl wget tree eza jq ripgrep fd-find bat procps coreutils
  # Shell / Prompt / Multiplexing
  zsh fzf zoxide tmux
  # grpc
  protobuf-compiler
  # System monitoring
  htop ncdu btop
  # Editor
  neovim
  # build prereqs for asdf / source builds
  ca-certificates build-essential
)
[[ -n "${SKIP_DOCKER:-}" ]] || APT_PKGS+=(docker.io)

log "apt-get update"
$SUDO apt-get update -y
log "Installing apt packages: ${APT_PKGS[*]}"
$SUDO apt-get install -y --no-install-recommends "${APT_PKGS[@]}"

# fd / bat ship under prefixed names on Debian/Ubuntu — expose canonical names.
if have fdfind && ! have fd; then ln -sf "$(command -v fdfind)" "${LOCAL_BIN}/fd"; fi
if have batcat && ! have bat; then ln -sf "$(command -v batcat)" "${LOCAL_BIN}/bat"; fi

# ----------------------------------------------------------------------------
# Binaries not in apt (or wrong package): yq, lazygit, glow, buf, grpcurl
# ----------------------------------------------------------------------------

# yq — mikefarah/yq (Go). NOTE: apt's `yq` is the unrelated Python yq, so we
# install the Go binary directly to match the Brewfile.
if ! have yq || ! yq --version 2>/dev/null | grep -qi mikefarah; then
  install_bin "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${GOARCH}" yq
else
  log "yq (mikefarah) already installed; skipping"
fi

# lazygit — jesseduffield/lazygit (tarball)
if ! have lazygit; then
  ver="$(latest_tag jesseduffield/lazygit)"; ver="${ver#v}"
  log "Installing lazygit ${ver}"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${ver}_Linux_${ALT}.tar.gz" \
    | tar -xz -C "$tmp" lazygit
  install -m 0755 "$tmp/lazygit" "${LOCAL_BIN}/lazygit"; rm -rf "$tmp"
else
  log "lazygit already installed; skipping"
fi

# glow — charmbracelet/glow (terminal markdown viewer, tarball)
if ! have glow; then
  ver="$(latest_tag charmbracelet/glow)"; ver="${ver#v}"
  log "Installing glow ${ver}"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/charmbracelet/glow/releases/latest/download/glow_${ver}_Linux_${ALT}.tar.gz" \
    | tar -xz -C "$tmp"
  install -m 0755 "$(find "$tmp" -name glow -type f | head -1)" "${LOCAL_BIN}/glow"; rm -rf "$tmp"
else
  log "glow already installed; skipping"
fi

# buf — bufbuild/buf (protobuf lint/build, single binary)
if ! have buf; then
  install_bin "https://github.com/bufbuild/buf/releases/latest/download/buf-Linux-${UNAME_M}" buf
else
  log "buf already installed; skipping"
fi

# grpcurl — fullstorydev/grpcurl (tarball)
if ! have grpcurl; then
  ver="$(latest_tag fullstorydev/grpcurl)"; ver="${ver#v}"
  log "Installing grpcurl ${ver}"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/fullstorydev/grpcurl/releases/latest/download/grpcurl_${ver}_linux_${ALT}.tar.gz" \
    | tar -xz -C "$tmp" grpcurl
  install -m 0755 "$tmp/grpcurl" "${LOCAL_BIN}/grpcurl"; rm -rf "$tmp"
else
  log "grpcurl already installed; skipping"
fi

# ----------------------------------------------------------------------------
# Starship prompt — official installer (not packaged in apt)
# ----------------------------------------------------------------------------
if ! have starship; then
  log "Installing starship"
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$LOCAL_BIN"
else
  log "starship already installed; skipping"
fi

# ----------------------------------------------------------------------------
# asdf — version manager (git checkout, per upstream guidance)
# ----------------------------------------------------------------------------
if [[ ! -d "${HOME}/.asdf" ]]; then
  log "Installing asdf -> ~/.asdf"
  git clone --depth 1 https://github.com/asdf-vm/asdf.git "${HOME}/.asdf"
else
  log "asdf already present at ~/.asdf; skipping"
fi

# ----------------------------------------------------------------------------
# Post-install notes
# ----------------------------------------------------------------------------
cat <<EOF

$(log "Done.")

Add the following to your shell rc (~/.zshrc or ~/.bashrc) if not already present:

  export PATH="\$HOME/.local/bin:\$PATH"      # fd, bat, yq, lazygit, glow, buf, grpcurl, starship
  . "\$HOME/.asdf/asdf.sh"                     # asdf (bash); zsh users: see asdf docs
  eval "\$(starship init zsh)"                 # or bash
  eval "\$(zoxide init zsh)"                    # or bash

Docker: add your user to the docker group to run without sudo, then re-login:
  sudo usermod -aG docker "\$USER"

Verify:
  for c in git gh eza jq yq rg fd bat fzf zoxide tmux starship lazygit glow \\
           protoc buf grpcurl htop btop ncdu nvim docker asdf; do
    command -v "\$c" >/dev/null && echo "ok  \$c" || echo "MISS \$c"
  done
EOF
