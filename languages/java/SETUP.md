# ☕ Java Setup (macOS)

This guide defines a **clean, reproducible Java toolchain** for macOS, designed for **large codebases** (Lucene, Spring, multi-module Maven/Gradle) and **low background CPU**.

---

## Big-repo performance defaults

These directories frequently cause **watcher explosions** and **slow searches**:

- `target/`, `build/`, `out/`, `dist/`
- `.gradle/`, `.m2/`
- `node_modules/` (common in full-stack repos)

Recommended VS Code settings (repo-local `.vscode/settings.json`):

```json
{
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/target/**": true,
    "**/build/**": true,
    "**/out/**": true,
    "**/.gradle/**": true,
    "**/.m2/**": true,
    "**/node_modules/**": true,
    "**/logs/**": true,
    "**/.box/**": true
  },
  "search.exclude": {
    "**/.git/**": true,
    "**/target/**": true,
    "**/build/**": true,
    "**/out/**": true,
    "**/.gradle/**": true,
    "**/.m2/**": true,
    "**/node_modules/**": true,
    "**/logs/**": true,
    "**/.box/**": true
  }
}
```