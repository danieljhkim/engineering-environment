# 📦 Data Engineering Installations

This document lists **data engineering tooling** and how it is installed.

Assumes:
- Core developer utilities are installed (`../INSTALLS.md`)
- Python + Java runtimes are handled in their own directories (`../python/`, `../java/`)

---

## Required (Homebrew)

### Spark
```bash
brew install apache-spark
```

### Local SQL engine
```bash
brew install duckdb
```

### Data plumbing / inspection
```bash
brew install parquet-tools
brew install kcat
```

| Tool | Purpose |
|-----|--------|
| `apache-spark` | Spark / PySpark local runtime |
| `duckdb` | Fast local analytics SQL engine |
| `parquet-tools` | Inspect Parquet metadata/data |
| `kcat` | Kafka topic inspection (formerly kafkacat) |

---

## Optional (Homebrew)

### Hadoop / Hive (legacy-style local testing)
```bash
brew install hadoop
brew install hive
```

> These are heavy and sometimes finicky on macOS. Install only if you need local reproduction.

### Kafka (local)
```bash
brew install kafka
```

### Trino (local query engine)
```bash
brew install trino
```

---

## Python packages (per-project venv)

In a repo `.venv`:

```bash
pip install pyspark pandas pyarrow fastparquet
pip install duckdb sqlalchemy psycopg2-binary
pip install apache-airflow
pipx install dbt-core dbt-postgres
```

Notes:
- Use `apache-airflow` locally only if you really need it; otherwise prefer Docker/managed.
- For BigQuery/Snowflake/Redshift targets, add the appropriate dbt adapters.

---

## Verification

```bash
spark-submit --version
pyspark --version
kcat -V
parquet-tools --help
```

---


