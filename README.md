# engineering-environment

Every time we get a new computer, whether for work or personal, it takes way too much time setting things up. Tools come and go, and it's time-consuming to keep up with the trend. 

To make things easier, I created **engineering-environment**:
- A reference engineering environment for modern infra & backend work.

This repo documents:
- What to install
- Why each tool exists
- Boostrap installs 
- Useful tools and scripts

---


## 📐 Repo Structure

```text
dev-setup/
├── Makefile                      # Bootstrap & verification commands
├── README.md
├── bin/                          # Repo-level utilities
├── core/                         # Core developer utilities
├── infra/                        # Cloud, platform, ops tooling
├── data-eng/                     # Data engineering tooling
├── workflow/                     # Daily workflow helpers
├── languages/                    # Language-specific setups
│   ├── java/
│   ├── go/
│   ├── nodejs/
│   └── python/
├── knowledge-system/
└── docs/                          # Misc docs
```

---

## 🧱 Layering Model

1. **Core** – shell, search, git, prompt
2. **Workflow** - opinionated daily dev ergonomics
3. **knowledge-system** - personal/team knowledge tooling
2. **Infra** – cloud, containers, orchestration
3. **Data-Eng** - data engineering
4. **Language** – runtime + tooling

---

## Tool Choices

### asdf

I chose **asdf** as the main version manager, since it can be used for many languages.
And we all speak multiple languages. So asdf makes sense. 

You can check it out here:
- https://github.com/asdf-vm/asdf


---

## 🛠️ Makefile (Bootstrap & Verification)

Make commands:

```bash
make help
make bootstrap-core
make bootstrap-infra
make bootstrap-java
make bootstrap-go
make bootstrap-node
make bootstrap-python
make bootstrap-data-eng
```

Verification helpers are also provided:

```bash
make verify-core
make verify-infra
make verify-data-eng
```

These are best-effort checks to confirm tools are installed and reachable.