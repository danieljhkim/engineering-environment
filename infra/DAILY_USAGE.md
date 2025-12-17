# ⚙️ Infra Daily Usage

This document captures **day-to-day workflows** for infrastructure, platform, and distributed systems work.

It assumes:
- Core developer utilities are installed
- Infra tooling from `infra/INSTALLS.md` is available

---

## ☁️ Cloud Authentication

### AWS (SSO preferred)

```bash
aws sso login --profile default
aws sts get-caller-identity
```

Tips:
- Prefer short-lived credentials
- Avoid static access keys in files

---

### GCP

```bash
gcloud auth login
gcloud auth list
```

Set project:

```bash
gcloud config set project <project-id>
```

---

## 🐳 Docker

### Start / stop Docker Desktop

Keep Docker **off when not in use** to save CPU and battery.

### Common commands

```bash
docker ps
docker images
docker build -t my-image .
docker run -p 8080:8080 my-image
```

Cleanup:

```bash
docker system prune
```

---

## ☸️ Kubernetes

### Context management

```bash
kubectl config get-contexts
kubectl config use-context <context>
```

### Common inspection

```bash
kubectl get pods
kubectl describe pod <pod>
kubectl logs <pod>
```

### Port forwarding

```bash
kubectl port-forward svc/my-service 8080:80
```

---

## 🧭 k9s Workflow

- `:` → command mode
- `pods` → list pods
- `deploy` → deployments
- `svc` → services
- `Ctrl + D` → describe
- `Ctrl + L` → logs

Use k9s for:
- Quick cluster health checks
- Live log inspection
- Resource navigation

---

## 📦 Terraform

### Typical workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Destroy (careful):

```bash
terraform destroy
```

Best practices:
- Always review `plan`
- Keep state remote
- Avoid manual cloud console changes

---

## 🌐 Networking & Debugging

### HTTP testing

```bash
http GET https://example.com
curl -v https://example.com
```

### Connectivity tests

```bash
nc -vz host 443
```

---

## 🔐 Secrets

### 1Password CLI

```bash
op signin
op item get "My Secret"
```

Rules:
- Never commit secrets
- Prefer runtime injection

---

## 🧠 Operating Principles

- CLI-first workflows
- Declarative configs over manual changes
- Ephemeral credentials
- Minimal always-on background processes

---

