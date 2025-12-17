# 📦 Node.js Installations

This file lists the tools used for Node.js development and how they are installed.

---

## Required (Homebrew)

### asdf
```bash
brew install asdf
```

### direnv
```bash
brew install direnv
```

### Node (bootstrap only)
```bash
brew install node
```

---

## Node versions (asdf-managed)

```bash
asdf plugin add nodejs
asdf install nodejs 22.11.0
asdf global nodejs 22.11.0
```

---

## Package manager (recommended)

Use pnpm via Corepack:

```bash
corepack enable
corepack prepare pnpm@latest --activate
pnpm -v
```

---

## Optional (recommended)

### Better monorepo + TS ergonomics
```bash
brew install watchman
```

| Tool | Purpose |
|-----|--------|
| `watchman` | Efficient file watching in large JS repos |

---

## Verification

```bash
node -v
npm -v
pnpm -v
asdf current nodejs
```

---


