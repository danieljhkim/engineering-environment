# ~/.zprofile — Linux (zsh login shell)
#
# Ported from configs/.zshrc (macOS). On this Ubuntu server zsh runs as a login
# shell, so the interactive setup lives here instead of ~/.zshrc.
#
# Differences vs the macOS .zshrc:
#   - No Homebrew (apt-based; tools live on the system PATH / ~/.local/bin)
#   - asdf sourced from ~/.asdf (git checkout) instead of `brew --prefix asdf`
#   - fzf integration sourced from the Debian/Ubuntu package paths
#   - macOS-only bits dropped: `open -e`, `sandbox-exec`, WezTerk.app PATH,
#     /opt/homebrew curl/postgres/openjdk paths
#   - Language/data-platform export blocks removed (install those via asdf)

# ------------------------------
# PATH / environment (always applied — even for non-interactive logins)
# ------------------------------
export PATH="$HOME/.local/bin:$PATH"   # fd, bat, yq, lazygit, glow, buf, grpcurl, starship
export EDITOR=nvim
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Go (harmless if Go isn't installed yet)
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# asdf (toolchain version manager) — installed at ~/.asdf
[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"

# Rust (only if installed via rustup)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ------------------------------
# Machine-specific env / overrides (per-host, NOT tracked in git)
# Put host PATH additions, JAVA_HOME, secrets, etc. here. Kept above the
# interactive guard so they apply to non-interactive logins too.
# ------------------------------
[ -f "$HOME/.zprofile.local" ] && . "$HOME/.zprofile.local"

# Everything below is zsh-specific. Bail out if this file is sourced by another
# shell (e.g. `source ~/.zprofile` from bash), or by a non-interactive login
# (scp/rsync/cron), so they stay clean and error-free.
[ -z "$ZSH_VERSION" ] && return
[[ $- != *i* ]] && return

echo "hola mundo"

# ------------------------------
# History
# ------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# ------------------------------
# Completion system
# ------------------------------
[ -d "$HOME/.asdf/completions" ] && fpath=("$HOME/.asdf/completions" $fpath)
autoload -Uz compinit && compinit

# ------------------------------
# Terminal left/right word jump
# ------------------------------
# Alt + Left / Alt + Right
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
# Many Linux terminals send Ctrl + Left / Right instead:
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# ------------------------------
# fzf
# ------------------------------
# Keep fzf + search fast by ignoring heavy dirs (Java/Go/Lucene big repos):
export BIG_REPO_EXCLUDES='{.git,node_modules,target,build,out,dist,.gradle,.idea,.m2,.cache,.box,logs,bin}'

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow \
  --exclude .git --exclude node_modules --exclude target --exclude build --exclude out --exclude dist \
  --exclude .gradle --exclude .idea --exclude .m2 --exclude .cache --exclude .box --exclude logs --exclude bin"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow \
  --exclude .git --exclude node_modules --exclude target --exclude build --exclude out --exclude dist \
  --exclude .gradle --exclude .idea --exclude .m2 --exclude .cache --exclude .box --exclude logs --exclude bin"

export FZF_DEFAULT_OPTS='
  --height=40%
  --layout=reverse
  --border
'

# fzf keybindings + completion (installed by the Debian/Ubuntu `fzf` package)
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ------------------------------
# zoxide
# ------------------------------
eval "$(zoxide init zsh)"
alias cd='z'

# ------------------------------
# Starship prompt
# ------------------------------
eval "$(starship init zsh)"

# ------------------------------
# direnv (per-project env vars; only if installed)
# ------------------------------
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# ------------------------------
# Aliases (minimal, useful)
# ------------------------------
alias gl='git log --oneline --graph --decorate'
alias source_z='source ~/.zprofile'
alias source_v='source .venv/bin/activate'
alias cat_z='cat ~/.zprofile'
alias vim_z='nvim ~/.zprofile'
alias open_z='xdg-open ~/.zprofile'   # macOS used `open -e`
alias open_ports='lsof -nP -i'        # or: ss -tulpn

# fzf alias
alias fzff="fzf --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"

# bat aliases  (Debian ships bat as `batcat`; install-linux.sh symlinks `bat`)
alias cat='bat --paging=never'
alias preview='bat'

# eza aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -lha --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'

# sandbox: macOS `sandbox-exec` has no direct Linux equivalent.
# Closest options (install separately): `firejail --net=none <cmd>`
# or `unshare -rn <cmd>` to run a command with no network namespace.

# ------------------------------
# Functions
# ------------------------------
git_c() {
  local branch

  branch=$(
    git for-each-ref --sort=-committerdate \
      --format='%(refname:short)' refs/heads refs/remotes \
    | grep -v 'origin/HEAD' \
    | fzf --height 40% --reverse --border \
        --preview '
          git log --oneline --graph --decorate --color=always -n 20 {} 2>/dev/null
        ' \
        --preview-window=right:60%
  ) || return

  # If remote branch selected (origin/foo), auto-track it
  if [[ "$branch" == origin/* ]]; then
    local local_branch="${branch#origin/}"
    git checkout -t "$branch" 2>/dev/null || git checkout "$local_branch"
  else
    git checkout "$branch"
  fi
}

kill_p() {
  local selection pid
  selection=$(ps -eo pid,comm | sed 1d | fzf) || return
  pid=$(awk '{print $1}' <<< "$selection")

  echo "Kill PID $pid? (y/N)"
  read -r confirm
  [[ "$confirm" == "y" ]] || return

  kill "$pid"
}

fcd() {
  local dir
  dir=$(fd --type d 2>/dev/null | fzf) && cd "$dir"
}
