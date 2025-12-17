# ⚙️ Data Engineering – Daily Usage Guide

This document captures **day-to-day workflows** for data engineering on a developer laptop.

It is optimized for:
- Spark / PySpark development
- SQL-first analytics
- Debugging batch + streaming pipelines
- Large datasets without killing your machine

---

## 🧭 Daily mindset

- Prefer **local iteration** before cluster execution
- Use **small samples** of data
- Keep heavy daemons **off** unless actively needed
- Treat prod clusters as read-only during debugging

---

## 🧪 Python + PySpark workflow

### Activate project environment

```bash
source .venv/bin/activate
```

### Run a Spark job locally

```bash
spark-submit jobs/etl_job.py
```

With custom config:

```bash
spark-submit \
  --conf spark.sql.shuffle.partitions=4 \
  --conf spark.driver.memory=2g \
  jobs/etl_job.py
```

Interactive shell:

```bash
pyspark
```

Spark SQL shell:

```bash
spark-shell
```

---

## 📊 DuckDB (fast local analytics)

DuckDB is ideal for:
- Validating transformations
- Exploring Parquet datasets
- SQL-first debugging

```bash
duckdb
```

Example:

```sql
SELECT COUNT(*) FROM 'data/events/*.parquet';
```

---

## 📦 Parquet inspection

Quick metadata checks:

```bash
parquet-tools schema data/file.parquet
parquet-tools meta data/file.parquet
parquet-tools head data/file.parquet
```

---

## 🌊 Kafka / Streaming

Inspect topics:

```bash
kcat -L -b localhost:9092
```

Consume messages:

```bash
kcat -C -b localhost:9092 -t events_topic
```

Produce test messages:

```bash
echo '{"event": "test"}' | kcat -P -b localhost:9092 -t events_topic
```

---

## 🗂️ Hadoop / Hive (if installed)

> Use sparingly — heavy on macOS.

Check HDFS:

```bash
hdfs dfs -ls /
```

Hive shell:

```bash
hive
```

Always stop daemons when done.

---

## 🧹 Performance hygiene

Regular cleanup:

```bash
rm -rf spark-warehouse metastore_db
```

Avoid watching large directories:
- `data/`
- `datasets/`
- `warehouse/`

---

## 🔐 Credentials & safety

- Use cloud SSO for cluster access
- Never test against prod topics/tables directly
- Log sample rows, not full datasets

---

## ✅ Quick checks

```bash
spark-submit --version
pyspark --version
duckdb --version
kcat -V
```

---


