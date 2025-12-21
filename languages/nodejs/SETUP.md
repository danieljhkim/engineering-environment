# 🟢 Node.js Setup (macOS)

This guide defines a **clean, reproducible Node.js toolchain** for macOS, optimized for **large repos**, fast installs, and predictable per-project versions.

## Goals

- Use **asdf** for Node version management (per-repo pinning)
- Use **pnpm** as the default package manager (fast, disk-efficient)
- Keep filesystem watchers and background CPU low in large repos
- Provide a simple daily workflow for backend + frontend projects

---

## Package manager: pnpm (recommended)

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

## Repo setup: pin Node version

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

## Big-repo performance defaults

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

## Optional: per-repo environment with `direnv`

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
