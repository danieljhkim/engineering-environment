# Knowledge System — Setup

This directory contains tooling and conventions for maintaining a **personal knowledge system** built on top of an Obsidian vault.  
The goal is to treat notes, decisions, and learning artifacts as **long-lived infrastructure**, not ad-hoc documents.

This system is optimized for:
- Daily engineering work logs
- Long-running project tracking
- Architectural decision records (ADR-like)
- Learning notes (algorithms, ML, systems)
- Lightweight personal ops (career, logs, retrospectives)

---

## Prerequisites

### Required
- **macOS or Linux**
- **Bash** (tested with `bash >= 4`)
- **Obsidian** (desktop app)

### Optional but Recommended
- Obsidian Community Plugin: **Dataview**
- Git (if you version your vault or parts of it)

---

## Directory Overview

This setup bootstraps an Obsidian vault with a **structured, opinionated layout**:

```text
vault/
├── 00-Inbox/                # Quick capture, unprocessed notes
├── 01-Daily/YYYY-MM/        # Daily notes (monthly partitioned)
├── 02-Projects/             # Active & archived projects
├── 03-Systems/              # Mental models, systems, frameworks
├── 04-Engineering/          # Language / infra-specific notes
├── 05-Learning/             # Algorithms, ML, reading notes
├── 06-Reference/            # Stable reference material
├── 07-Career/               # Career planning, interviews, goals
├── 08-Logs/                 # Debugging & performance logs
├── _Templates/              # Obsidian templates
├── Dashboard.md             # Dataview-powered dashboard
└── README.md                # Vault entry point
```