# 🧰 Core Developer Environment (macOS)

This document defines the **baseline developer toolchain** shared across all languages.

---

## 🐚 Shell & Prompt

### zsh
- **Role:** Default shell
- **Why:** Stable, scriptable, native to macOS
- **Config:** `~/.zshrc`

### Starship
- **Role:** Cross-shell prompt
- **Why:** Fast, minimal, language-aware without lag
- **Config:** `~/.config/starship.toml`
- **Design goals:**
  - Instant render
  - Low noise
  - Safe for very large repos

### fzf
- **Role:** Fuzzy finder
- **Why:** Fast navigation of files, dirs, and history
- **Key bindings:**
  - `Ctrl + T` → files
  - `Alt + C` → directories
- **Backed by:** `fd`

---

## 🔍 Search & Navigation (Big‑Repo Safe)

### fd
- **Role:** Fast file finder (replacement for `find`)
- **Why:** Orders of magnitude faster
- **Used by:** `fzf`

### bat
- **Role:** Better `cat` (syntax-highlighted file viewer)
- **Why:** Fast previews in terminal + integrates well with `fzf`
- **Config:** `~/.config/bat/config`
- **Common setup:**
  - `bat --generate-config-file`
  - Set theme/paging as needed (e.g., `--theme`, `--paging=never`)

### eza
- **Role:** Modern `ls` replacement (colors, icons, git status)
- **Why:** More readable directory listings by default
- **Config:** Usually via shell aliases in `~/.zshrc` (flags + defaults)
- **Common setup:**
  - `alias ls='eza'`
  - `alias ll='eza -lah --git'`
  - `alias tree='eza --tree'`

### ripgrep (rg)
- **Role:** Ultra-fast text search
- **Why:** Handles millions of lines instantly
- **Config:** `~/.ripgreprc`
- **Default excludes:**
  - `.git/`
  - `node_modules/`
  - `target/`, `build/`, `out/`, `dist/`
  - `.gradle/`, `.idea/`, `.m2/`, `.box/`, `logs/`

---

## 🧩 Environment & Version Control

### git
- **Role:** Version control
- **Why:** Industry standard
- **Config:** `~/.gitconfig`

### gh
- **Role:** GitHub CLI
- **Why:** PRs, issues, auth without browser context switches

---

## 🧠 Design Philosophy

- ⚡ Fast shell startup
- 🔍 Predictable search behavior
- 📁 Safe defaults for large monorepos
- 🧊 Minimal background CPU usage
- 🧱 Language-agnostic baseline

---

## 📁 Important Files

| File | Purpose |
|------|--------|
| `~/.zshrc` | Shell configuration |
| `~/.config/starship.toml` | Prompt configuration |
| `~/.ripgreprc` | Search defaults |
| `~/.gitconfig` | Git configuration |

---

