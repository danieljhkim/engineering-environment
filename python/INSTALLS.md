# 📦 Python Installations

This file lists the tools used for Python development and how they are installed.

---

## Required (Homebrew)

### asdf
```bash
brew install asdf
```

### Python (bootstrap only)
```bash
brew install python
```

---

## Python versions (asdf-managed)

```bash
asdf plugin add python
asdf install python 3.12.7
asdf global python 3.12.7
```

---

## Required Python tooling (installed per-venv)

```bash
pip install pip setuptools wheel
```

---

## Optional (recommended)

### Formatting & linting

```bash
pip install black ruff
```

### Testing

```bash
pip install pytest
```

### Type checking

```bash
pip install mypy
```

---

## Optional (data / ML)

```bash
pip install numpy pandas scipy matplotlib scikit-learn
```

---

## Verification

```bash
python --version
pip --version
pytest --version
```

---


