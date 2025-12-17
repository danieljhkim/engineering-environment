

# Brewfile.java
# Java tooling (non-runtime)
#
# Philosophy:
# - Keep JDK installation/version pinning in java/SETUP.md (asdf or a single Homebrew JDK)
# - Put Java *tooling* here: build tools, linters, dependency helpers

tap "homebrew/bundle"

# Build & dependency tooling
brew "maven"
brew "gradle"

# Useful CLI utilities for JVM repos
brew "protobuf"     # protoc compiler
brew "buf"          # protobuf lint/build tooling
brew "grpcurl"      # gRPC debugging

# Optional (enable if you want a Homebrew-managed JDK)
# brew "temurin"     # Eclipse Temurin JDK
# brew "openjdk@21"  # Example pinned JDK

# Optional quality-of-life
# brew "jenv"        # Alternative JDK switcher (only if NOT using asdf)
# brew "google-java-format" # Formatter CLI (if you prefer it)