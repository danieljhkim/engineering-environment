# 📦 Core Developer Utilities (Homebrew)

This document lists **only the baseline tools** required for a productive developer environment.

---

## 🧱 Core CLI Utilities

```bash
brew install git gh curl wget tree eza jq yq ripgrep fd bat htop watch coreutils
```

| Tool | Purpose |
|-----|--------|
| `git` | Version control |
| `gh` | GitHub CLI |
| `curl` | HTTP requests |
| `wget` | File downloads |
| `tree` | Directory visualization |
| `eza` | Better `ls` |
| `jq` | JSON processing |
| `yq` | YAML processing |
| `ripgrep` | Fast code search |
| `fd` | Fast file finder |
| `bat` | Better `cat` |
| `htop` | CPU / process monitor |
| `watch` | Periodic command runner |
| `coreutils` | GNU utilities |

---

## 🐚 Shell & Prompt

```bash
brew install zsh starship fzf
```

| Tool | Purpose |
|-----|--------|
| `zsh` | Default shell |
| `starship` | Minimal prompt |
| `fzf` | Fuzzy finder |

---

## 🧩 Optional Shell Enhancements

```bash
brew install zoxide
```

| Tool | Purpose |
|-----|--------|
| `zoxide` | Smart directory jumping |

---

## 🔤 Fonts (Optional but Recommended)

```bash
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono
```

---

## 📌 Notes

- This list is the **minimum shared baseline**
- Language-specific installs live under their own directories
- Snapshot with `brew bundle dump` when stable

---


