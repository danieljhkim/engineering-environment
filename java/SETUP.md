# ☕ Java Setup (macOS)

This guide defines a **clean, reproducible Java toolchain** for macOS, designed for **large codebases** (Lucene, Spring, multi-module Maven/Gradle) and **low background CPU**.

## Goals

- Homebrew-managed **OpenJDK 21** as the global default
- Predictable `JAVA_HOME` (no version flapping)
- Good defaults for Maven + Gradle
- Optional per-repo tuning via `direnv`

---

## 1) Install (Homebrew)

Install the JDK:

```bash
brew install openjdk@21
```

Expose the JDK to macOS (needed for some tools that expect `/Library/Java/JavaVirtualMachines/...`):

```bash
sudo ln -sfn \
  $(brew --prefix openjdk@21)/libexec/openjdk.jdk \
  /Library/Java/JavaVirtualMachines/openjdk-21.jdk
```

Verify:

```bash
java -version
/usr/libexec/java_home
```

---

## 2) Pin `JAVA_HOME` (recommended)

To avoid ambiguity when multiple JDKs are installed, pin Java to Homebrew in `~/.zshrc`:

```zsh
# Java (Homebrew-managed)
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
```

Verify:

```bash
echo $JAVA_HOME
which java
java -version
```

---

## 3) Build Tools

### Maven
Install:

```bash
brew install maven
```

Sanity check:

```bash
mvn -v
```

### Gradle
Install:

```bash
brew install gradle
```

Sanity check:

```bash
gradle -v
```

---

## 4) Big-repo performance defaults

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

---

## 5) Optional: per-repo tuning with `direnv`

If you use `direnv`, you can tune JVM/build behavior per repository without changing global config.

Example `.envrc`:

```bash
# Maven
export MAVEN_OPTS="-Xmx2g"

# Gradle: keep background usage low on laptops / dev boxes
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.workers.max=2"
```

Activate once:

```bash
direnv allow
```

---

## 6) Notes: Java version management

This setup intentionally uses **Homebrew only** for Java.

- ✅ Stable toolchain for IDEs, build tools, and language servers
- ❌ Avoids `asdf` Java shims and multi-JDK ambiguity

If you later need multiple JDKs (e.g., 17 + 21), add a small helper script (recommended) rather than swapping global defaults.

---

## Quick check list

```bash
java -version
mvn -v
gradle -v
echo $JAVA_HOME
```


