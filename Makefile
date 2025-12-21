# Dev Setup Makefile
# Intentionally simple, readable, and explicit

.DEFAULT_GOAL := help

.PHONY: help \
	bootstrap-core bootstrap-infra bootstrap-java bootstrap-go bootstrap-node bootstrap-python bootstrap-data-eng \
	verify-core verify-infra verify-data-eng

help:
	@echo "Available commands:" 
	@echo ""
	@echo "  make bootstrap-core       Install core developer utilities"
	@echo "  make bootstrap-infra      Install infra / cloud tooling"
	@echo "  make bootstrap-java       Install Java toolchain (brew + asdf assumed)"
	@echo "  make bootstrap-go         Install Go toolchain (brew + asdf assumed)"
	@echo "  make bootstrap-node       Install Node.js toolchain (brew + asdf assumed)"
	@echo "  make bootstrap-python     Install Python toolchain (brew + asdf assumed)"
	@echo "  make bootstrap-data-eng   Install data engineering tooling"
	@echo ""
	@echo "Verification helpers:" 
	@echo "  make verify-core"
	@echo "  make verify-infra"
	@echo "  make verify-data-eng"

# -----------------------------
# Bootstrap targets
# -----------------------------

bootstrap-core:
	@echo "🔧 Installing core developer utilities"
	brew bundle --file core/Brewfile
	@echo "✅ Core tools installed"

bootstrap-infra:
	@echo "☁️ Installing infra tooling"
	brew bundle --file infra/Brewfile
	@echo "✅ Infra tools installed"

bootstrap-java:
	@echo "☕ Installing Java tooling (non-runtime)"
	brew bundle --file languages/java/Brewfile
	@echo "ℹ️  JDK version pinning is handled via asdf (see languages/java/SETUP.md)"
	@echo "✅ Java tooling installed"

bootstrap-go:
	@echo "🐹 Installing Go tooling (non-runtime)"
	brew bundle --file languages/go/Brewfile
	@echo "ℹ️  Go version pinning is handled via asdf (see languages/go/SETUP.md)"
	@echo "✅ Go tooling installed"

bootstrap-node:
	@echo "🟢 Installing Node.js tooling (non-runtime)"
	brew bundle --file languages/nodejs/Brewfile
	@echo "ℹ️  Node.js version pinning is handled via asdf (see languages/nodejs/SETUP.md)"
	@echo "✅ Node.js tooling installed"

bootstrap-python:
	@echo "🐍 Installing Python tooling (non-runtime)"
	brew bundle --file languages/python/Brewfile
	@echo "ℹ️  Python version pinning is handled via asdf (see languages/python/SETUP.md)"
	@echo "✅ Python tooling installed"

bootstrap-data-eng:
	@echo "📊 Installing data engineering tooling"
	brew bundle --file data-eng/Brewfile
	@echo "✅ Data engineering tools installed"

# -----------------------------
# Verification targets (best-effort)
# -----------------------------

verify-core:
	@echo "🔍 Verifying core tools"
	git --version
	gh --version
	rg --version
	fd --version

verify-infra:
	@echo "🔍 Verifying infra tools"
	kubectl version --client=true || true
	terraform version || true
	aws --version || true
	gcloud --version || true

verify-data-eng:
	@echo "🔍 Verifying data engineering tools"
	spark-submit --version || true
	duckdb --version || true
	kcat -V || true
