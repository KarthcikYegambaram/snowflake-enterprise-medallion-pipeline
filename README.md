# Pharma Sales Medallion Architecture Pipeline

End-to-end Snowflake Data Engineering project implementing:

- Medallion Architecture
- Incremental Loading
- CDC using Streams
- Task Automation
- SCD Type 2
- Star Schema Modeling

---

# Architecture

Source → Bronze → Silver → Gold

## Layers

### Bronze Layer
- Raw ingestion
- Stream-based CDC
- Audit columns
- Batch tracking

### Silver Layer
- Data cleansing
- Standardization
- Validation
- Rejected records handling

### Gold Layer
- Dimension tables
- Fact tables
- SCD Type 2
- Analytics-ready star schema

---

# Technologies Used

- Snowflake
- SQL
- Streams
- Tasks
- SCD Type 2
- Star Schema

---

# Features

- Incremental data processing
- Automated pipeline execution
- Historical tracking using SCD2
- Data quality validation
- Fact and dimension modeling

---

# Project Flow

1. Source table ingestion
2. Bronze raw storage
3. Silver cleansing & validation
4. Gold dimension loading
5. Fact table loading
6. Automated task orchestration

---

# Pipeline Components

## Streams
Used for CDC and incremental processing.

## Tasks
Used for scheduling and automation.

## SCD Type 2
Implemented for:
- DIM_BRANCH
- DIM_MEDICINE

---

# Example Fact Table Metrics

- Quantity Sold
- Unit Price
- Discount Rate
- Line Total

---

# Future Improvements

- Snowpipe integration
- DBT transformation layer
- Power BI dashboards
- CI/CD deployment

---

# Author

Karthick Yegambaram