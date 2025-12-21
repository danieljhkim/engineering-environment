# 🐹 Go Setup (macOS)

This guide defines a **clean, reproducible Go toolchain** for macOS, optimized for **backend services, CLIs, and large repos** with fast builds and low background overhead.

## Goals

- Use **asdf** for Go version management
- Predictable `GOROOT`, `GOPATH`, and `GOBIN`
- Simple global defaults, per-repo overrides when needed
- Fast builds and tooling for large codebases

---

## 1) Install prerequisites

Install core tooling via Homebrew:

```bash
brew install asdf go
```

> `go` from Homebrew is only used for bootstrapping; **asdf-managed Go is authoritative**.

---

## 2) Configure Go via asdf (recommended)

Add the Go plugin:

```bash
asdf plugin add golang
```

Install a Go version:

```bash
asdf install golang 1.23.4
asdf global golang 1.23.4
```

Verify:

```bash
go version
asdf current golang
```

---

## 3) Environment layout (standard)

Recommended defaults (usually already handled by asdf):

```bash
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
```

Directory structure:

```text
$HOME/go/
├── bin/        # installed tools
├── pkg/        # cached packages
└── src/        # legacy workspace (rarely used)
```

---

## 4) Go modules (default)

All modern Go projects should use modules.

```bash
go env -w GO111MODULE=on
```

Inside a repo:

```bash
go mod init github.com/yourorg/project
go mod tidy
```

---

## 5) Common development commands

```bash
go test ./...
go build ./...
go run ./cmd/server
```

Format and vet:

```bash
go fmt ./...
go vet ./...
```

---

## 6) Tooling (installed via `go install`)

Recommended global tools:

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
```

Verify:

```bash
which gopls
which dlv
```

---

## 7) Big-repo performance defaults

Avoid filesystem watchers and search slowdowns by excluding:

- `bin/`, `dist/`, `out/`
- `vendor/`
- `.cache/`, `.idea/`, `.vscode/`

Recommended VS Code repo-local settings (`.vscode/settings.json`):

```json
{
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/bin/**": true,
    "**/dist/**": true,
    "**/out/**": true,
    "**/vendor/**": true
  },
  "search.exclude": {
    "**/.git/**": true,
    "**/bin/**": true,
    "**/dist/**": true,
    "**/out/**": true,
    "**/vendor/**": true
  }
}
```

---

## 8) Optional: per-repo config with `.tool-versions`

Pin Go per repository:

```bash
easdf local golang 1.23.4
```

This creates:

```text
.tool-versions
golang 1.23.4
```

---

## 9) Notes & philosophy

- Go is intentionally **managed via asdf**, not Homebrew
- Global installs are kept minimal
- Repo-local version pinning is preferred for long-lived services

