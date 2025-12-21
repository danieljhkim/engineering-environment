# 📦 Python Installations

This document describes how to set up Python development using **asdf** for
version management and **pipx** for global Python CLI tools.

The goal:
- asdf → manages Python versions
- pipx → installs Python CLI tools safely and globally
- pip / uv → installs per-project dependencies

---

## Prerequisites

### Homebrew (bootstrap only)

```bash
brew install asdf
```

Ensure asdf is initialized in your shell (`~/.zshrc`):

```zsh
. "$(brew --prefix asdf)/libexec/asdf.sh"
fpath=("${ASDF_DIR:-$(brew --prefix asdf)}/share/zsh/site-functions" $fpath)
autoload -Uz compinit && compinit
```

Restart your shell and verify:
```bash
asdf --version
```

---

## Python versions (asdf-managed)

### Add Python plugin (one-time)

```bash
asdf plugin add python
```

### Install and set a global Python

```bash
asdf install python 3.12.7
asdf set -u python 3.12.7
asdf reshim python
```

Verify:
```bash
python --version
which python
```

Expected:
- `python` → `~/.asdf/shims/python`
- Version matches `3.12.7`

---

## pipx (global Python CLI tools)

### Install pipx using asdf Python

```bash
python -m pip install --upgrade pip
python -m pip install --user pipx
python -m pipx ensurepath
```

Restart your shell (required).

Verify:
```bash
pipx --version
pipx environment
```

Ensure pipx binaries are on PATH:
```bash
echo $PATH | tr ':' '\n' | grep .local/bin
```

---

## Global Python CLI tools (pipx-managed)

These tools are available **from any directory** and do not pollute project
environments.

### Formatting & linting

```bash
pipx install ruff
```

(Optional, only if not using Ruff formatting)
```bash
pipx install black
```

### Testing

```bash
pipx install pytest
```

### Type checking

```bash
pipx install mypy
```

### Packaging / workflow

```bash
pipx install uv
pipx install poetry
pipx install pip-tools
```

### Utilities (optional)

```bash
pipx install ipython
pipx install httpie
pipx install awscli
```

---

## Project dependencies (per-venv)

Project libraries should **not** be installed globally.

Use one of:
- `uv`
- `pip + venv`
- `poetry`

Example (uv):

```bash
uv venv
source .venv/bin/activate
uv pip install requests rich
```

---

## Optional (data / ML – per project only)

```bash
pip install numpy pandas scipy matplotlib scikit-learn
```

(Install inside a virtual environment.)

---

## Verification

```bash
python --version
pipx list
ruff --version
pytest --version
mypy --version
```

---

## Recommended Mental Model

```text
brew  → bootstrap tools
asdf  → language runtimes
pipx  → Python CLI apps
pip   → project dependencies
```