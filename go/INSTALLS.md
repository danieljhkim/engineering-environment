# 📦 Go Installations

This file lists the tools used for Go development and how they are installed.

---

## Required (Homebrew)

### asdf
```bash
brew install asdf
```

### Go (bootstrap only)
```bash
brew install go
```

---

## Go versions (asdf-managed)

```bash
asdf plugin add golang
asdf install golang 1.23.4
asdf global golang 1.23.4
```

---

## Required Go tools

Installed via `go install`:

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
```

| Tool | Purpose |
|-----|--------|
| `gopls` | Go language server |
| `dlv` | Debugger |
| `staticcheck` | Static analysis |

---

## Optional (recommended)

```bash
brew install golangci-lint
```

| Tool | Purpose |
|-----|--------|
| `golangci-lint` | Aggregated Go linters |

---

## Verification

```bash
go version
gopls version
dlv version
```

---


