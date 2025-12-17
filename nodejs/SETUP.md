# 🟢 Node.js Setup (macOS)

This guide defines a **clean, reproducible Node.js toolchain** for macOS, optimized for **large repos**, fast installs, and predictable per-project versions.

## Goals

- Use **asdf** for Node version management (per-repo pinning)
- Use **pnpm** as the default package manager (fast, disk-efficient)
- Keep filesystem watchers and background CPU low in large repos
- Provide a simple daily workflow for backend + frontend projects

---

## 1) Install prerequisites

Install core tooling via Homebrew:

```bash
brew install asdf direnv
```

Install Node tooling:

```bash
brew install node
```

> `node` from Homebrew is fine for quick scripts, but **asdf-managed Node is authoritative** for development projects.

---

## 2) Install Node via asdf (recommended)

Add the Node.js plugin:

```bash
asdf plugin add nodejs
```

Install a Node version:

```bash
asdf install nodejs 22.11.0
asdf global nodejs 22.11.0
```

Verify:

```bash
node -v
npm -v
asdf current nodejs
```

---

## 3) Package manager: pnpm (recommended)

Install pnpm via Corepack (preferred):

```bash
corepack enable
corepack prepare pnpm@latest --activate
pnpm -v
```

### Why pnpm?

- Faster installs than npm in many repos
- Disk-efficient (content-addressed store)
- Works well in monorepos

---

## 4) Repo setup: pin Node version

Inside a project repo:

```bash
asdf local nodejs 22.11.0
```

This creates or updates:

```text
.tool-versions
nodejs 22.11.0
```

---

## 5) Big-repo performance defaults

Avoid watcher explosions and slow searches by excluding:

- `node_modules/`
- `.next/`, `dist/`, `build/`, `out/`
- `.turbo/`, `.cache/`
- `coverage/`, `.nyc_output/`

Recommended VS Code repo-local settings (`.vscode/settings.json`):

```json
{
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/node_modules/**": true,
    "**/.next/**": true,
    "**/dist/**": true,
    "**/build/**": true,
    "**/out/**": true,
    "**/.turbo/**": true,
    "**/.cache/**": true,
    "**/coverage/**": true,
    "**/.nyc_output/**": true,
    "**/logs/**": true,
    "**/.box/**": true
  },
  "search.exclude": {
    "**/.git/**": true,
    "**/node_modules/**": true,
    "**/.next/**": true,
    "**/dist/**": true,
    "**/build/**": true,
    "**/out/**": true,
    "**/.turbo/**": true,
    "**/.cache/**": true,
    "**/coverage/**": true,
    "**/.nyc_output/**": true,
    "**/logs/**": true,
    "**/.box/**": true
  }
}
```

---

## 6) Optional: per-repo environment with `direnv`

Useful for projects with many env vars (API keys, DB urls, feature flags).

Example `.envrc`:

```bash
export NODE_ENV=development
export PORT=3000
```

Activate once:

```bash
direnv allow
```

---

## 7) Common workflows

### Install dependencies

```bash
pnpm install
```

### Run dev server

```bash
pnpm dev
```

### Build

```bash
pnpm build
```

### Test

```bash
pnpm test
```

---

## 8) Notes & philosophy

- Node is intentionally **managed via asdf**, not Homebrew
- `corepack + pnpm` gives reproducible installs without extra global tooling
- Repo-local `.tool-versions` keeps CI + local aligned

---

## Quick checklist

```bash
node -v
pnpm -v
asdf current nodejs
```


