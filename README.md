# engineering-environment

A reference engineering environment for modern infra & backend work.

This repo documents:
- What to install
- Why each tool exists
- How layers build on top of each other

The goal is **a predictable, performant engineering environment with low cognitive load**.

---

## 📐 Repo Structure

```text
engineering-environment/
├── SETUP.md        # Core, language-agnostic developer utilities
├── INSTALLS.md
├── infra/          # Cloud, platform, ops tooling
│   ├── SETUP.md
│   ├── INSTALLS.md
│   └── DAILY_USAGE.md
├── java/           # Java-specific setup
├── go/             # Go-specific setup
├── nodejs/         # Node.js setup
├── python/         # Python setup
```

---

## 🧱 Layering Model

1. **Core** – shell, search, git, prompt
2. **Infra** – cloud, containers, orchestration
3. **Language** – runtime + tooling
4. **Project** – repo-local config

Each layer:
- Depends only on layers below it
- Avoids duplication
- Has a clear responsibility

---

## 🛠️ Makefile (Bootstrap & Verification)

This repo includes a top-level `Makefile` that provides **explicit, layer-aware bootstrap commands**.

The Makefile is intentionally simple:
- No hidden installs
- No runtime version pinning
- No side effects beyond Homebrew bundles

### Common commands

```bash
make help
make bootstrap-core
make bootstrap-infra
make bootstrap-java
make bootstrap-go
make bootstrap-node
make bootstrap-python
make bootstrap-data-eng
```

Each `bootstrap-*` target:
- Installs tooling for a single layer via the corresponding `Brewfile`
- Leaves runtime version management to each language’s `SETUP.md`

Verification helpers are also provided:

```bash
make verify-core
make verify-infra
make verify-data-eng
```

These are best-effort checks to confirm tools are installed and reachable.

---

## 🎯 Design Principles

- CLI-first
- Minimal background CPU
- Big-repo safe defaults
- Reproducible installs
- Easy to audit and rebuild

---

## 🚀 How to Use

1. Start with `SETUP.md` + `INSTALLS.md`
2. Add `infra/` if doing platform or cloud work
3. Add only the language directories you need
4. Keep project-specific config out of this repo (this repo defines the environment, not individual projects)

---

## 📌 Non-Goals

- One-click bootstrap scripts
- IDE-specific setup
- OS-level hardening



