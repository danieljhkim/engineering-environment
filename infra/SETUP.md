# 🏗️ Infrastructure & Platform Setup (macOS)

This document defines **infrastructure-focused developer tooling** used for:

- Platform / infra engineering
- Distributed systems development
- Cloud-native services
- Networking, containers, and ops workflows

It **builds on top of** the core developer utilities and intentionally excludes:
- Language runtimes (Java / Go / Python / Node)
- IDE-specific configuration

---

## Goals

- Predictable, scriptable infra tooling
- CLI-first workflows
- Safe defaults for large repos and clusters
- Minimal background CPU when idle

---

## ☁️ Cloud CLIs

### AWS CLI
- **Role:** Primary AWS interaction
- **Use cases:** IAM, EC2, S3, EKS, CloudWatch
- **Auth:** SSO preferred

### Google Cloud SDK
- **Role:** GCP interaction
- **Use cases:** GKE, Cloud Storage, IAM

### Azure CLI (optional)
- **Role:** Azure interaction
- **Use cases:** AKS, resource management

---

## 🐳 Containers & Orchestration

### Docker
- **Role:** Local container runtime
- **Scope:** Local dev only (not prod-like)

### Kubernetes CLI (kubectl)
- **Role:** Cluster interaction
- **Use cases:** Deployments, logs, debugging

### k9s
- **Role:** Terminal UI for Kubernetes
- **Why:** Fast inspection without context switching

---

## 🌐 Networking & Debugging

### curl / httpie
- **Role:** HTTP debugging

### tcpdump (system)
- **Role:** Packet inspection

### netcat (nc)
- **Role:** Low-level networking tests

---

## 📦 Infrastructure as Code

### Terraform
- **Role:** Declarative infra provisioning
- **Why:** Industry standard

### Helm
- **Role:** Kubernetes packaging

---

## 🔐 Secrets & Credentials

### 1Password CLI (optional)
- **Role:** Secure secret access

---

## 🧠 Philosophy & Practices

- Infra tools are **CLI-first**
- Avoid GUI-only workflows
- Prefer declarative configs checked into git
- Keep cloud credentials ephemeral (SSO / short-lived tokens)

---

## Quick verification

```bash
aws --version
kubectl version --client
terraform version
docker --version
```


