# ❄️ Snowflake Enterprise Medallion Architecture Pipeline

> End-to-end ELT pipeline built entirely in native Snowflake SQL — implementing Medallion Architecture with CDC, SCD Type 2, Streams & Tasks automation, data quality validation, and audit logging.

`Snowflake` `SQL` `CDC` `Streams & Tasks` `SCD Type 2` `Medallion Architecture` `Data Engineering`

---

## 📌 Project Overview

Built a production-style data pipeline on Snowflake that processes pharmaceutical sales transaction data through three medallion layers (Bronze → Silver → Gold). The pipeline handles incremental loads, change data capture, data quality enforcement, and delivers an analytics-ready star schema — all using Snowflake-native features, no external orchestration tools.

---

## 🏗️ Architecture

```
Source Table
     │
     ▼
 Source Stream (CDC)
     │
     ▼
 Bronze Layer  ──── Raw ingestion, hash diff, batch tracking
     │
     ▼
 Bronze Stream (CDC)
     │
     ▼
 Silver Layer  ──── Validation, cleansing, rejected records
     │
     ├──► Rejected Records Table
     │
     ▼
 Gold Layer    ──── SCD Type 2 Dims + Fact Table (Star Schema)
```

![Architecture](architecture/medallion-architecture.png)

---

## 🔄 CDC & Change Handling

Full change data capture using Snowflake Streams, supporting all operation types:

| Operation | Handled |
|---|---|
| INSERT | ✅ |
| UPDATE | ✅ |
| DELETE | ✅ |
| SOFT DELETE | ✅ |
| INCREMENTAL LOAD | ✅ |

---

## 🥉 Bronze Layer

Raw ingestion layer capturing all CDC events from the source.

- Stream-based CDC capture
- Insert / Update / Delete handling
- Hash diff generation for change detection
- Batch ID and metadata tracking
- Soft delete flagging

---

## 🥈 Silver Layer

Cleansing and validation layer with business rule enforcement.

- Incremental MERGE processing
- Data type casting and standardisation
- Soft delete propagation
- Failed records routed to a **Rejected Records** table
- Full audit log of each pipeline run

**Validation rules include:** null transaction IDs, invalid dates, invalid payment methods, age out of range (0–120), quantity ≤ 0, price ≤ 0, discount outside 0–1, expired medicine, missing branch/city fields.

---

## 🥇 Gold Layer

Analytics-ready dimensional model in a star schema.

**Dimension Tables (SCD Type 2):**
- `DIM_DATE`
- `DIM_BRANCH`
- `DIM_CUSTOMER`
- `DIM_MEDICINE`
- `DIM_SUPPLIER`

**Fact Table:**
- `FACT_SALES`

![Star Schema](screenshots/star-schema.png)

### SCD Type 2 Logic

Each dimension tracks full history using three control columns:

| Column | Purpose |
|---|---|
| `_IS_CURRENT` | Flags the active record |
| `_EFFECTIVE_FROM` | Record start timestamp |
| `_EFFECTIVE_TO` | Record expiry timestamp |

When a dimension attribute changes: the current row is expired, and a new version is inserted — preserving complete history.

![SCD2 Flow](screenshots/scd2-flow.png)

---

## ⚙️ Automation — Streams & Tasks

The entire pipeline runs automatically via chained Snowflake Tasks triggered by Streams.

```
Source Stream → Bronze Task → Bronze Stream → Silver Task → Gold Dim Task → Fact Task
```

![Task Flow](screenshots/streams-tasks-flow.png)

Resume tasks to activate the pipeline:
```sql
ALTER TASK TASK_LOAD_BRONZE RESUME;
ALTER TASK TASK_LOAD_SILVER RESUME;
ALTER TASK TASK_LOAD_GOLD_DIMS RESUME;
ALTER TASK TASK_LOAD_FACT_SALES RESUME;
```

---

## 📋 Audit Logging

Every pipeline execution is logged with:
- Rows processed / inserted / updated / rejected
- Batch ID
- Execution timestamp
- Task status

---

## 📁 Folder Structure

```
├── sql/
│   ├── 01_create_schemas.sql
│   ├── 02_bronze_layer.sql
│   ├── 03_silver_layer.sql
│   ├── 04_gold_layer.sql
│   ├── 05_streams_tasks.sql
│   ├── 06_fact_tables.sql
│   ├── 07_monitoring_queries.sql
│   └── full_pipeline.sql
├── sample data/
│   └── pharma_sales_sample.csv
├── architecture/
├── screenshots/
└── README.md
```

---

## 🚀 How to Run

1. Create the database:
   ```sql
   CREATE DATABASE PHARMA_DW;
   ```
2. Load source data into `PUBLIC.PHARMA_SALES`

3. Enable change tracking:
   ```sql
   ALTER TABLE PUBLIC.PHARMA_SALES SET CHANGE_TRACKING = TRUE;
   ```

4. Run SQL scripts in order (`01` → `07`)

5. Resume tasks to start the automated pipeline

---

## 🔍 Monitoring

```sql
-- Check task history
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
ORDER BY SCHEDULED_TIME DESC;

-- Check stream status
SHOW STREAMS IN DATABASE PHARMA_DW;
```

---

## 👤 Author
**Karthick Yegambaram** · [GitHub](https://github.com/KarthcikYegambaram)
