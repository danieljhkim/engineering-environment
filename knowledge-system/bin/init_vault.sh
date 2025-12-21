#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./init_vault.sh "/path/to/your/vault"
# Example:
#   ./init_vault.sh "$HOME/notes/vault"

VAULT_DIR="${1:-}"
if [[ -z "$VAULT_DIR" ]]; then
  echo "Usage: $0 /path/to/vault"
  exit 1
fi

mkdir -p "$VAULT_DIR"

# ---------- Folder structure ----------
mkdir -p "$VAULT_DIR/00-Inbox"
mkdir -p "$VAULT_DIR/01-Daily"
MONTH="$(date +%Y-%m)"
mkdir -p "$VAULT_DIR/01-Daily/$MONTH"
mkdir -p "$VAULT_DIR/02-Projects"
mkdir -p "$VAULT_DIR/03-Systems"
mkdir -p "$VAULT_DIR/04-Engineering/Java"
mkdir -p "$VAULT_DIR/04-Engineering/Python"
mkdir -p "$VAULT_DIR/04-Engineering/Infra"
mkdir -p "$VAULT_DIR/05-Learning/Algorithms"
mkdir -p "$VAULT_DIR/05-Learning/ML"
mkdir -p "$VAULT_DIR/05-Learning/Reading"
mkdir -p "$VAULT_DIR/06-Reference"
mkdir -p "$VAULT_DIR/07-Career"
mkdir -p "$VAULT_DIR/08-Logs/Debugging"
mkdir -p "$VAULT_DIR/08-Logs/Debugging/$MONTH"
mkdir -p "$VAULT_DIR/08-Logs/Performance"
mkdir -p "$VAULT_DIR/08-Logs/Performance/$MONTH"
mkdir -p "$VAULT_DIR/_Templates"

# ---------- Templates ----------
cat > "$VAULT_DIR/_Templates/Daily.md" <<'EOF'
# {{date:YYYY-MM-DD}}

## Focus
- 

## Work Log
- 

## Learnings
- 

## Decisions
- 

## Loose Thoughts
- 
EOF

cat > "$VAULT_DIR/_Templates/Project.md" <<'EOF'
# {{title}}

## Goal
-

## Context
-

## Architecture
- 

## Key Decisions
- 

## Open Problems
- 

## Links
- 
EOF

cat > "$VAULT_DIR/_Templates/System.md" <<'EOF'
# {{title}}

## Definition
-

## Why it matters
-

## Key tradeoffs
- 

## Failure modes
- 

## Used in
- 

## References
- 
EOF

cat > "$VAULT_DIR/_Templates/Decision.md" <<'EOF'
# Decision: {{title}}

## Context
-

## Options Considered
1. 
2. 

## Decision
-

## Consequences
-
EOF

# ---------- Starter projects ----------
declare -a PROJECTS=("dsearch")

for p in "${PROJECTS[@]}"; do
  mkdir -p "$VAULT_DIR/02-Projects/$p"
  # Project index note
  if [[ ! -f "$VAULT_DIR/02-Projects/$p/$p.md" ]]; then
    cat > "$VAULT_DIR/02-Projects/$p/$p.md" <<EOF
---
status: active
priority: P2
next_action: ""
---

# ${p}

## Goal
-

## Architecture
- 

## Key Decisions
- 

## Open Problems
- 

## Links
- [[${p} - decisions]]
- [[${p} - open-questions]]
EOF
  fi

  # Decisions + open questions notes
  [[ -f "$VAULT_DIR/02-Projects/$p/${p} - decisions.md" ]] || cat > "$VAULT_DIR/02-Projects/$p/${p} - decisions.md" <<EOF
# ${p} - decisions

- 
EOF

  [[ -f "$VAULT_DIR/02-Projects/$p/${p} - open-questions.md" ]] || cat > "$VAULT_DIR/02-Projects/$p/${p} - open-questions.md" <<EOF
# ${p} - open-questions

- 
EOF
done

# ---------- Today's daily note (from template + project links) ----------
TODAY="$(date +%F)"
MONTH="$(date +%Y-%m)"
DAILY_DIR="$VAULT_DIR/01-Daily/$MONTH"
DAILY_PATH="$DAILY_DIR/$TODAY.md"
DAILY_TEMPLATE="$VAULT_DIR/_Templates/Daily.md"

mkdir -p "$DAILY_DIR"

if [[ ! -f "$DAILY_PATH" ]]; then
  if [[ -f "$DAILY_TEMPLATE" ]]; then
    TMP_RENDERED="$(mktemp)"
    TMP_FINAL="$(mktemp)"

    sed "s/{{date:YYYY-MM-DD}}/$TODAY/g" "$DAILY_TEMPLATE" > "$TMP_RENDERED"

    awk 'NR==1 {
      print;
      print "";
      print "## Projects";
      print "- [[dsearch]]";
      print "";
      next
    } { print }' "$TMP_RENDERED" > "$TMP_FINAL"

    cat "$TMP_FINAL" > "$DAILY_PATH"
    rm -f "$TMP_RENDERED" "$TMP_FINAL"
  else
    cat > "$DAILY_PATH" <<EOF
# $TODAY

## Projects
- [[dsearch]]

## Focus
- 

## Work Log
- 

## Learnings
- 

## Decisions
- 

## Loose Thoughts
- 
EOF
  fi
fi

# ---------- Dataview dashboard skeleton ----------
DASHBOARD_PATH="$VAULT_DIR/Dashboard.md"
if [[ ! -f "$DASHBOARD_PATH" ]]; then
  cat > "$DASHBOARD_PATH" <<'EOF'
# Dashboard

> Requires the **Dataview** community plugin.
> In Obsidian: Settings → Community plugins → Browse → “Dataview” → Install → Enable

---

## Today
```dataview
LIST
FROM "01-Daily"
WHERE file.name = dateformat(date(today), "yyyy-MM-dd")
```

---

## Recent Daily Notes
```dataview
LIST
FROM "01-Daily"
SORT file.day DESC
LIMIT 14
```

---

## Project Status
```dataview
TABLE status, priority, next_action, file.mtime as "Last Modified"
FROM "02-Projects"
WHERE status
SORT priority ASC, file.mtime DESC
```

---

## Active Projects
```dataview
LIST
FROM "02-Projects"
WHERE status = "active"
SORT file.mtime DESC
```

---

## Open Tasks (All Notes)
```dataview
TASK
FROM ""
WHERE !completed
SORT file.mtime DESC
```

---

## Inbox (triage)
```dataview
LIST
FROM "00-Inbox"
SORT file.mtime DESC
LIMIT 25
```

---

## Recently Edited (anywhere)
```dataview
LIST
FROM ""
SORT file.mtime DESC
LIMIT 20
```
EOF
fi

# ---------- Root README ----------
cat > "$VAULT_DIR/README.md" <<'EOF'
# Obsidian Vault

## Start here
- Dashboard: `Dashboard.md`
- Daily notes: `01-Daily/`
- Projects: `02-Projects/`
- Systems: `03-Systems/`
- Templates: `_Templates/`
P
Tip: Start each day with a note in `01-Daily/` and link to projects/systems as you go.
EOF

echo "✅ Vault initialized at: $VAULT_DIR"
echo "✅ Starter projects created under: 02-rojects/"
echo "✅ Today's daily note: $DAILY_PATH"
echo "✅ Dataview dashboard: $DASHBOARD_PATH"
echo ""
echo "Next steps:"
echo "  1) Open Obsidian → 'Open folder as vault' → $VAULT_DIR"
echo "  2) Settings → Core plugins → Templates → set folder to _Templates"
echo "  3) Settings → Community plugins → Install & enable Dataview"