# 📦 Java Installations (asdf)

This document describes how to install and manage the Java toolchain using **asdf**.
asdf is the single source of truth for Java versions and works cleanly with
multi-project, multi-JDK setups.

> Homebrew is **not** used for installing Java itself.
> (It may still be used for Maven, Gradle, and general CLI tooling.)

---

## Prerequisites

- asdf ≥ 0.16 installed and initialized in your shell
- `asdf java` plugin

Verify:
```bash
asdf --version
```

---

## Install Java via asdf (Recommended)

### Add the Java plugin (one-time)
```bash
asdf plugin add java
```

---

### Install Java 21 (LTS, Eclipse Temurin)

List available Java 21 builds:
```bash
asdf list all java | grep temurin-21
```

Install the latest LTS build (example):
```bash
asdf install java temurin-21.0.9+10.0.LTS
```

---

### Set Java 21 as the default

Global (recommended):
```bash
asdf set -u java temurin-21.0.9+10.0.LTS
```

Per-project (writes `.tool-versions`):
```bash
asdf set java temurin-21.0.9+10.0.LTS
```

Verify:
```bash
java -version
javac -version
echo $JAVA_HOME
```

Expected:
- `openjdk version "21.x" LTS`
- `JAVA_HOME` points to `~/.asdf/installs/java/...`

If needed:
```bash
asdf reshim java
hash -r
```

---

## Maven & Gradle (via Homebrew)

These tools respect `JAVA_HOME` set by asdf.

```bash
brew install maven gradle
```

Verify:
```bash
mvn -v
gradle -v
```

---

## Optional: Additional JDKs (Recommended)

Keep multiple LTS versions for legacy projects:

```bash
asdf install java temurin-17.0.12+7
```

Switch per project using `.tool-versions`.

---

## Useful Build & Infra Tooling

```bash
brew install make cmake ninja
brew install ripgrep fd jq yq htop
```

---

## IntelliJ IDEA Setup (Important)

IntelliJ does **not** read your shell PATH.

1. **Settings → Project Structure → SDKs**
2. **Add SDK → JDK**
3. Select:
   ```
   ~/.asdf/installs/java/temurin-21.0.9+10.0.LTS
   ```
4. Set as:
   - Project SDK
   - Gradle JVM

---

## Notes / Gotchas

- Do **not** install `openjdk` via Homebrew when using asdf
- Do **not** manually symlink into `/Library/Java/JavaVirtualMachines`
- asdf manages `JAVA_HOME` automatically
- `.tool-versions` is the canonical source of truth

---

## Verification Checklist

```bash
which java
java -version
asdf current java
```

Expected:
- `java` → `~/.asdf/shims/java`
- Version matches `.tool-versions` or global default
