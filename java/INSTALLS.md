# 📦 Java Installations (Homebrew)

This file lists the Homebrew packages used for the Java toolchain.

---

## Required

### OpenJDK 21
```bash
brew install openjdk@21
```

### Maven
```bash
brew install maven
```

### Gradle
```bash
brew install gradle
```

---

## Optional (recommended for Java/Lucene work)

### Build helpers
```bash
brew install make cmake ninja
```

### Useful CLI tooling (if not installed globally)
```bash
brew install ripgrep fd jq yq htop
```

---

## Post-install steps

Expose the Homebrew JDK to macOS:

```bash
sudo ln -sfn \
  $(brew --prefix openjdk@21)/libexec/openjdk.jdk \
  /Library/Java/JavaVirtualMachines/openjdk-21.jdk
```

Pin `JAVA_HOME` to Homebrew in `~/.zshrc`:

```zsh
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
```

Verify:

```bash
java -version
mvn -v
gradle -v
```

---


