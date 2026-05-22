
-- ============================================================
-- BRONZE STREAM
-- ============================================================

CREATE OR REPLACE STREAM KARTHICKY_DB."1_BRONZE".STREAM_BRONZE_TO_SILVER

ON TABLE KARTHICKY_DB."1_BRONZE".PHARMA_SALES_RAW

SHOW_INITIAL_ROWS = TRUE;
