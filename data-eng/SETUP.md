# 🧱 Data Engineering Setup (macOS)

This document defines **data engineering tooling** for macOS, aimed at:

- PySpark / Spark SQL development
- Hadoop / Hive style batch workflows (local + remote)
- Streaming pipelines (Kafka)
- Warehousing + orchestration (dbt / Airflow)

It **builds on**:
- `../SETUP.md` + `../INSTALLS.md` (core utilities)
- `../infra/` (cloud/cluster tooling) when you need AWS/GCP/K8s

It intentionally excludes:
- Language runtime setup (see `../python/` and `../java/`)

---

## Goals

- Fast local iteration for Spark / SQL
- Reproducible Python environments (no global pip)
- Clear separation of local tooling vs cluster tooling
- Big-repo safe defaults (low background CPU)

---

## 1) Recommended baseline (what you actually need most days)

### Spark (local) + PySpark

- For local Spark, Homebrew `apache-spark` is usually enough.
- Use Python `.venv` per repo (see `../python/SETUP.md`).

Typical project layout:

```text
repo/
├── .venv/
├── jobs/
│   ├── etl_job.py
│   └── ...
├── sql/
│   └── transforms.sql
└── requirements.txt
```

Run local Spark job:

```bash
spark-submit jobs/etl_job.py
```

Interactive:

```bash
pyspark
spark-shell
```

---

## 2) Hadoop & Hive (local dev philosophy)

Local Hadoop/Hive can be useful for:
- Understanding file formats, partitions, and metastore behavior
- Running small-scale reproductions

But for most modern workflows:
- Prefer Spark local mode + SQL engines (DuckDB) for fast iteration
- Use real clusters (EMR/Dataproc) for integration tests

If you do run Hadoop locally:
- Keep it **off** when idle (it’s heavy)
- Prefer small datasets + minimal daemons

---

## 3) Python tooling (per-project)

Inside a project repo:

```bash
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip setuptools wheel
```

Recommended data-eng baseline:

```bash
pip install pyspark pandas pyarrow fastparquet
pip install duckdb sqlalchemy psycopg2-binary
pip install dbt-core dbt-postgres
pip install apache-airflow
```

> Airflow can be heavy; many teams run it in Docker or use managed Airflow instead.

---

## 4) Useful local SQL engines

### DuckDB
Great for:
- Local analytics
- Reproducible SQL transforms
- Testing parquet datasets quickly

Example:

```bash
duckdb
```

---

## 5) Streaming (Kafka)

Local Kafka is best used for:
- Testing producers/consumers
- Verifying schema evolution behavior

Use cases:
- `kcat` for fast inspection
- `kafka-topics` / `kafka-console-consumer` for quick sanity checks

---

## 6) Big-repo performance defaults

Exclude common data/cache folders:

- `.venv/`, `__pycache__/`
- `data/`, `datasets/`, `warehouse/` (large)
- `spark-warehouse/`
- `metastore_db/`
- `logs/`, `tmp/`

Recommended VS Code repo-local settings (`.vscode/settings.json`):

```json
{
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/.venv/**": true,
    "**/__pycache__/**": true,
    "**/data/**": true,
    "**/datasets/**": true,
    "**/warehouse/**": true,
    "**/spark-warehouse/**": true,
    "**/metastore_db/**": true,
    "**/logs/**": true,
    "**/tmp/**": true
  },
  "search.exclude": {
    "**/.git/**": true,
    "**/.venv/**": true,
    "**/__pycache__/**": true,
    "**/data/**": true,
    "**/datasets/**": true,
    "**/warehouse/**": true,
    "**/spark-warehouse/**": true,
    "**/metastore_db/**": true,
    "**/logs/**": true,
    "**/tmp/**": true
  }
}
```

---

## 7) Environment variables (common)

These are common in Spark/Hadoop contexts:

```bash
export SPARK_HOME="$(brew --prefix)/opt/apache-spark/libexec"
export HADOOP_HOME="$(brew --prefix)/opt/hadoop/libexec"
export HIVE_HOME="$(brew --prefix)/opt/hive/libexec"
```

> Only set `HADOOP_HOME` / `HIVE_HOME` if you actually install those tools locally.

---

## Quick verification

```bash
spark-submit --version
pyspark --version
python -c "import pyspark; print(pyspark.__version__)"
duckdb --version
```


