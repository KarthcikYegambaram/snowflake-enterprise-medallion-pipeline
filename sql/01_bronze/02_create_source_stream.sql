
-- ============================================================
-- SOURCE STREAM
-- ============================================================

CREATE OR REPLACE STREAM KARTHICKY_DB.PUBLIC.STREAM_PHARMA_SALES_RAW

ON TABLE KARTHICKY_DB.PUBLIC.PHARMA_SALES

SHOW_INITIAL_ROWS = TRUE;
