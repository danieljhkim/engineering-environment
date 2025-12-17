# 🐍 Python Setup (macOS)

This guide defines a **clean, reproducible Python toolchain** for macOS, optimized for **backend services, data/ML work, scripting**, and large repositories with predictable environments.

## Goals

- Use **asdf** for Python version management
- Use **venv** (or `uv` optionally) for per-project isolation
- Keep global Python clean (no `pip install` globally)
- Fast installs, low background CPU, reproducible builds

---

## 1) Install prerequisites

Install core tooling via Homebrew:

```bash
brew install asdf python
```

> Homebrew Python is used for bootstrapping only; **asdf-managed Python is authoritative** for projects.

---

## 2) Install Python via asdf (recommended)

Add the Python plugin:

```bash
asdf plugin add python
```

Install a Python version:

```bash
asdf install python 3.12.7
asdf global python 3.12.7
```

Verify:

```bash
python --version
pip --version
asdf current python
```

---

## 3) Per-project virtual environments (standard)

Create and activate a virtual environment inside a repo:

```bash
python -m venv .venv
source .venv/bin/activate
```

Upgrade core tooling:

```bash
pip install --upgrade pip setuptools wheel
```

Deactivate when done:

```bash
deactivate
```

---

## 4) Dependency management

### Recommended

- Use `requirements.txt` for services / scripts
- Use `pyproject.toml` for libraries

Example:

```bash
pip install -r requirements.txt
```

Freeze dependencies:

```bash
pip freeze > requirements.txt
```

---

## 5) Big-repo performance defaults

Avoid watcher explosions and slow searches by excluding:

- `.venv/`, `__pycache__/`
- `.pytest_cache/`, `.mypy_cache/`
- `build/`, `dist/`
- `.tox/`, `.eggs/`

Recommended VS Code repo-local settings (`.vscode/settings.json`):

```json
{
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/.venv/**": true,
    "**/__pycache__/**": true,
    "**/.pytest_cache/**": true,
    "**/.mypy_cache/**": true,
    "**/build/**": true,
    "**/dist/**": true,
    "**/.tox/**": true,
    "**/.eggs/**": true,
    "**/logs/**": true
  },
  "search.exclude": {
    "**/.git/**": true,
    "**/.venv/**": true,
    "**/__pycache__/**": true,
    "**/.pytest_cache/**": true,
    "**/.mypy_cache/**": true,
    "**/build/**": true,
    "**/dist/**": true,
    "**/.tox/**": true,
    "**/.eggs/**": true,
    "**/logs/**": true
  }
}
```

---

## 6) Optional: per-repo environment with `direnv`

Useful for data/ML projects or services with many env vars.

Example `.envrc`:

```bash
export PYTHONUNBUFFERED=1
export ENV=development
```

Activate once:

```bash
direnv allow
```

---

## 7) Common workflows

```bash
pytest
python main.py
python -m package.module
```

Format & lint (if configured):

```bash
black .
ruff check .
```

---

## 8) Notes & philosophy

- Python versions are **managed via asdf**
- Virtual environments are **repo-local**
- Global Python remains clean and stable

---

## Quick checklist

```bash
python --version
which python
pip list
```


