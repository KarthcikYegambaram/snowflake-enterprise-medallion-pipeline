

-- ============================================================
-- FILE: data_quality_validations.sql
-- PURPOSE: Data Quality Validation Queries
-- PROJECT: Snowflake Enterprise Medallion Architecture
-- ============================================================

-- ============================================================
-- 1. NULL TRANSACTION ID CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE TRANSACTION_ID IS NULL;

-- ============================================================
-- 2. INVALID TRANSACTION DATE CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE TRANSACTION_DATE IS NULL;

-- ============================================================
-- 3. INVALID EXPIRY DATE CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE EXPIRY_DATE < TRANSACTION_DATE;

-- ============================================================
-- 4. NULL BRANCH ID CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE BRANCH_ID IS NULL;

-- ============================================================
-- 5. MISSING BRANCH NAME CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE BRANCH_NAME IS NULL
   OR TRIM(BRANCH_NAME) = '';

-- ============================================================
-- 6. INVALID PAYMENT METHOD CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE UPPER(PAYMENT_METHOD)
NOT IN ('CASH', 'CARD', 'INSURANCE');

-- ============================================================
-- 7. INVALID CUSTOMER GENDER CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE UPPER(CUSTOMER_GENDER)
NOT IN ('MALE', 'FEMALE');

-- ============================================================
-- 8. INVALID CUSTOMER AGE CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE CUSTOMER_AGE < 0
   OR CUSTOMER_AGE > 120
   OR CUSTOMER_AGE IS NULL;

-- ============================================================
-- 9. MISSING CUSTOMER CITY CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE CUSTOMER_CITY IS NULL
   OR TRIM(CUSTOMER_CITY) = '';

-- ============================================================
-- 10. NULL MEDICINE ID CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE MEDICINE_ID IS NULL;

-- ============================================================
-- 11. INVALID DOSAGE FORM CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE UPPER(DOSAGE_FORM)
NOT IN (
    'TABLET',
    'CAPSULE',
    'SYRUP',
    'DROPS',
    'CREAM',
    'OINTMENT',
    'INHALER',
    'SACHET'
);

-- ============================================================
-- 12. INVALID PACK SIZE CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE PACK_SIZE <= 0
   OR PACK_SIZE IS NULL;

-- ============================================================
-- 13. INVALID PRESCRIPTION REQUIRED CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE PRESCRIPTION_REQUIRED IS NULL;

-- ============================================================
-- 14. INVALID QUANTITY CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE QUANTITY <= 0
   OR QUANTITY IS NULL;

-- ============================================================
-- 15. INVALID UNIT PRICE CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE UNIT_PRICE_LKR <= 0
   OR UNIT_PRICE_LKR IS NULL;

-- ============================================================
-- 16. INVALID DISCOUNT RATE CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE DISCOUNT_RATE < 0
   OR DISCOUNT_RATE > 1
   OR DISCOUNT_RATE IS NULL;

-- ============================================================
-- 17. INVALID LINE TOTAL CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE LINE_TOTAL_LKR <= 0
   OR LINE_TOTAL_LKR IS NULL;

-- ============================================================
-- 18. INVALID YEAR CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE YEAR < 2000
   OR YEAR > 2100
   OR YEAR IS NULL;

-- ============================================================
-- 19. INVALID MONTH CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE MONTH < 1
   OR MONTH > 12
   OR MONTH IS NULL;

-- ============================================================
-- 20. DUPLICATE TRANSACTION CHECK
-- ============================================================

SELECT
    TRANSACTION_ID,
    COUNT(*) AS RECORD_COUNT
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
GROUP BY TRANSACTION_ID
HAVING COUNT(*) > 1;

-- ============================================================
-- 21. SOFT DELETED RECORDS CHECK
-- ============================================================

SELECT *
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN
WHERE _IS_SOFT_DELETED = TRUE;

-- ============================================================
-- 22. REJECTED RECORDS SUMMARY
-- ============================================================

SELECT
    REJECT_REASON,
    COUNT(*) AS TOTAL_RECORDS
FROM KARTHICKY_DB."2_SILVER".REJECTED_RECORDS
GROUP BY REJECT_REASON
ORDER BY TOTAL_RECORDS DESC;

-- ============================================================
-- 23. CDC ACTION SUMMARY
-- ============================================================

SELECT
    _CDC_ACTION,
    COUNT(*) AS TOTAL_RECORDS
FROM KARTHICKY_DB."1_BRONZE".PHARMA_SALES_RAW
GROUP BY _CDC_ACTION;

-- ============================================================
-- 24. PIPELINE AUDIT SUMMARY
-- ============================================================

SELECT
    TASK_NAME,
    LAYER,
    STATUS,
    ROWS_PROCESSED,
    ROWS_INSERTED,
    ROWS_UPDATED,
    ROWS_REJECTED,
    _EXECUTED_AT
FROM KARTHICKY_DB."2_SILVER".PIPELINE_AUDIT_LOG
ORDER BY _EXECUTED_AT DESC;

-- ============================================================
-- 25. SOURCE TO TARGET RECONCILIATION
-- ============================================================

SELECT 'SOURCE_COUNT' AS TABLE_NAME, COUNT(*) AS TOTAL_ROWS
FROM KARTHICKY_DB.PUBLIC.PHARMA_SALES

UNION ALL

SELECT 'BRONZE_COUNT', COUNT(*)
FROM KARTHICKY_DB."1_BRONZE".PHARMA_SALES_RAW

UNION ALL

SELECT 'SILVER_COUNT', COUNT(*)
FROM KARTHICKY_DB."2_SILVER".PHARMA_SALES_CLEAN

UNION ALL

SELECT 'FACT_COUNT', COUNT(*)
FROM KARTHICKY_DB."3_GOLD".FACT_SALES;

