echo "hola mundo"

# ------------------------------
# PATH / Homebrew
# ------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"


# ------------------------------
# asdf (toolchain version manager)
# ------------------------------
. "$(brew --prefix asdf)/libexec/asdf.sh"
fpath=($(brew --prefix asdf)/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit


# ------------------------------
# History
# ------------------------------
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
autoload -Uz compinit
compinit

# Wizterm
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# ------------------------------
# Terminal left right jump
# ------------------------------
# Option + Left
bindkey "^[[1;3D" backward-word

# Option + Right
bindkey "^[[1;3C" forward-word


# ------------------------------
# fzf
# ------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS='
  --height=40%
  --layout=reverse
  --border
'

# Keybindings installed by fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh


eval "$(zoxide init zsh)"
alias cd='z'

# ------------------------------
# add local bin to PATH 
# ------------------------------
export PATH="/Users/daniel/.local/bin:$PATH"


# ------------------------------
# Starship prompt
# ------------------------------
eval "$(starship init zsh)"

# ------------------------------
# Aliases (minimal, useful)
# ------------------------------
alias ll='ls -lh'
alias la='ls -lha'
alias gl='git log --oneline --graph --decorate'
alias source_z='source ~/.zshrc'
alias source_v='source .venv/bin/activate'
alias cat_z='cat ~/.zshrc'
alias vim_z='vim ~/.zshrc'
alias open_z='open -e ~/.zshrc'
alias rufffix='ruff check . --fix && ruff format .'
alias open_ports='lsof -nP -i'

# fzf alias
alias fzff="fzf --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"

# bat aliases
alias cat='bat --paging=never'
alias preview='bat'

# eza aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'

# sandbox
alias sandbox-no-network='sandbox-exec -p "(version 1)(allow default)(deny network*)"'


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

# ------------------------------
# Editor
# ------------------------------
export EDITOR=nvim
export PATH="/opt/homebrew/opt/curl/bin:$PATH"


# ------------------------------
# Big-repo defaults (Java/Go/Lucene)
# ------------------------------
# Keep fzf + search fast by ignoring heavy dirs:
export BIG_REPO_EXCLUDES='{.git,node_modules,target,build,out,dist,.gradle,.idea,.m2,.cache,.box,logs,bin}'

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow \
  --exclude .git --exclude node_modules --exclude target --exclude build --exclude out --exclude dist \
  --exclude .gradle --exclude .idea --exclude .m2 --exclude .cache --exclude .box --exclude logs --exclude bin"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow \
  --exclude .git --exclude node_modules --exclude target --exclude build --exclude out --exclude dist \
  --exclude .gradle --exclude .idea --exclude .m2 --exclude .cache --exclude .box --exclude logs --exclude bin"

# ripgrep defaults for big repos
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"


# ------------------------------
# direnv (per-project env vars)
# ------------------------------
eval "$(direnv hook zsh)"


# ------------------------------
# GO
# ------------------------------
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"


# ------------------------------
# RUST
# ------------------------------
source "$HOME/.cargo/env"


# ------------------------------
# local data platform
# ------------------------------
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
# export PATH="$HOME/repos/local-data-platform/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"

# >>> local-data-platform >>>
# Hadoop
#export HADOOP_HOME="/opt/homebrew/opt/hadoop/libexec"
#export HADOOP_CONF_DIR="/opt/homebrew/opt/hadoop/libexec/etc/hadoop"
#export PATH="/opt/homebrew/opt/hadoop/libexec/bin:/opt/homebrew/opt/hadoop/libexec/sbin:$PATH"

# Hive
#export HIVE_HOME="/opt/homebrew/opt/hive/libexec"
#export HIVE_CONF_DIR="/opt/homebrew/opt/hive/libexec/conf"
#export PATH="/opt/homebrew/opt/hive/libexec/bin:$PATH"

# Spark
#export SPARK_HOME="/opt/homebrew/opt/apache-spark/libexec"
#export SPARK_CONF_DIR="/opt/homebrew/opt/apache-spark/libexec/conf"
#export PATH="/opt/homebrew/opt/apache-spark/libexec/bin:$PATH"

# <<< local-data-platform <<<


#export HADOOP_COMMON_HOME="$HADOOP_HOME"
#export HADOOP_HDFS_HOME="$HADOOP_HOME"
#export HADOOP_MAPRED_HOME="$HADOOP_HOME"
#export HADOOP_YARN_HOME="$HADOOP_HOME"



