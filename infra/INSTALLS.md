# 📦 Infrastructure Tooling Installations

This document lists **infrastructure and platform tooling** installed via Homebrew.

It assumes **core developer utilities** are already installed.

---

## ☁️ Cloud CLIs

```bash
brew install awscli google-cloud-sdk azure-cli
```

| Tool | Purpose |
|-----|--------|
| awscli | AWS CLI |
| google-cloud-sdk | GCP SDK |
| azure-cli | Azure CLI (optional) |

---

## 🐳 Containers & Kubernetes

```bash
brew install docker kubectl kubernetes-helm k9s
```

| Tool | Purpose |
|-----|--------|
| docker | Container runtime |
| kubectl | Kubernetes CLI |
| helm | Kubernetes package manager |
| k9s | Kubernetes TUI |

> Docker Desktop must be installed separately for the daemon.

---

## 🌐 Networking & Debugging

```bash
brew install httpie netcat
```

| Tool | Purpose |
|-----|--------|
| httpie | Human-friendly HTTP client |
| netcat | Network debugging |

---

## 📦 Infrastructure as Code

```bash
brew install terraform
```

| Tool | Purpose |
|-----|--------|
| terraform | Infra provisioning |

---

## 🔐 Secrets (Optional)

```bash
brew install --cask 1password
brew install 1password-cli
```

| Tool | Purpose |
|-----|--------|
| 1password | Password manager |
| 1password-cli | Secure CLI secret access |

---

## 📌 Notes

- Infra tools change frequently — pin versions where possible
- Prefer CLI auth over long-lived static credentials
- Keep Docker running only when needed

---

## Verification

```bash
aws --version
gcloud version
kubectl version --client
terraform version
```


