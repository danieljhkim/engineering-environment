# 🐍 Python Setup (macOS)

This guide defines a **clean, reproducible Python toolchain** for macOS, optimized for **backend services, data/ML work, scripting**, and large repositories with predictable environments.

## Goals

- Use **asdf** for Python version management
- Use **uv** for per-project isolation (venv + dependency management)
- Keep global Python clean (no `pip install` globally)
- Fast installs, low background CPU, reproducible builds

---

## Per-project virtual environments (uv)

Create and activate a virtual environment inside a repo:

```bash
uv venv
source .venv/bin/activate
```

If you need a specific Python version (asdf-managed), you can be explicit:

```bash
uv venv --python 3.12
source .venv/bin/activate
```

Tip: you can also avoid activation entirely for one-off commands:

```bash
uv run python -V
uv run pytest
```

Deactivate when done:

```bash
deactivate
```

---

## Dependency management

### Recommended

- Prefer `pyproject.toml` + `uv.lock` for projects you control
- Use `requirements.txt` when you’re consuming an existing pip-style workflow

Example:

```bash
uv pip install -r requirements.txt
```

Freeze dependencies:

```bash
uv pip freeze > requirements.txt
```

For `pyproject.toml` projects:

```bash
# install from pyproject.toml + uv.lock (creates/updates uv.lock as needed)
uv sync

# add a dependency
uv add requests
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

## Optional: per-repo environment with `direnv`

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

