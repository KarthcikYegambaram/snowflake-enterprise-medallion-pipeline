# Snowflake Enterprise Medallion Architecture Pipeline

![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Warehouse-blue)
![SQL](https://img.shields.io/badge/SQL-Advanced-green)
![CDC](https://img.shields.io/badge/CDC-Streams%20%26%20Tasks-orange)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-purple)

## Project Overview

This project demonstrates a complete enterprise-grade Medallion Architecture implementation in Snowflake using:

- Bronze, Silver, Gold layers
- CDC (Change Data Capture)
- Snowflake Streams
- Snowflake Tasks
- SCD Type 2 Dimensions
- Soft Deletes
- Audit Logging
- Data Quality Validation
- Fact and Dimension Modeling

The pipeline processes pharmaceutical sales transactional data and supports:

- Inserts
- Updates
- Deletes
- Soft Deletes
- Incremental Loads
- Historical Tracking

## Architecture

![Architecture](images/medallion-architecture.png)


### Bronze Layer

Raw ingestion layer storing CDC records directly from source tables.

Features:
- Streams-based ingestion
- Raw historical storage
- Metadata tracking
- Hash diff generation
- Batch ID tracking

### Silver Layer

Validated and transformed layer implementing business rules.

Features:
- Data cleansing
- Validation checks
- Reject handling
- Soft deletes
- Incremental merge logic

### Gold Layer

Business-ready dimensional model.

Features:
- Star schema
- SCD Type 2 dimensions
- Fact table loading
- Historical tracking
- Analytics-ready model

## CDC Features

The project supports:

- INSERT handling
- UPDATE handling
- DELETE handling
- SOFT DELETE implementation
- HASH DIFF change detection
- Incremental processing

## SCD Type 2 Implementation

Dimensions support full historical tracking using:

- _IS_CURRENT
- _EFFECTIVE_FROM
- _EFFECTIVE_TO

## Technologies Used

- Snowflake
- SQL
- Streams
- Tasks
- Change Data Capture (CDC)
- Data Warehousing
- Medallion Architecture
- Star Schema
- SCD Type 2

## Key Engineering Concepts

- Enterprise Data Warehousing
- Incremental Data Loading
- CDC Pipelines
- Streams & Tasks
- Medallion Architecture
- SCD Type 2
- Data Validation
- Audit Logging
- Dimensional Modeling
- ETL/ELT
