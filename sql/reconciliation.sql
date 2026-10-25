DROP TABLE IF EXISTS gold.reconciliation_result; 
 
CREATE TABLE gold.reconciliation_result AS 
WITH txn_week AS ( 
  SELECT merchant_id, batch_date, COUNT(*) AS txn_count, SUM(amount) AS txn_total 
  FROM ( 
    SELECT m.merchant_id, f.amount, 
           d.full_date + ((7 - EXTRACT(DOW FROM d.full_date)::int) % 7) AS batch_date 
    FROM gold.fact_transactions f 
    JOIN gold.dim_merchant m ON m.merchant_sk = f.merchant_sk 
    JOIN gold.dim_date d     ON d.date_sk     = f.date_sk 
    WHERE f.status = 'SUCCESS' 
  ) x 
  GROUP BY merchant_id, batch_date 
), 
settle AS ( 
  SELECT m.merchant_id, d.full_date AS batch_date, s.settlement_id, s.total_amount, s.settled_amount 
  FROM gold.fact_stellement s 
  JOIN gold.dim_merchant m ON m.merchant_sk = s.merchant_sk 
  JOIN gold.dim_date d     ON d.date_sk     = s.date_sk 
) 
SELECT COALESCE(s.merchant_id, t.merchant_id) AS merchant_id, 
       COALESCE(s.batch_date, t.batch_date)   AS batch_date, 
       s.settlement_id, t.txn_count, t.txn_total, s.total_amount, s.settled_amount, 
       t.txn_total - s.total_amount AS level1_diff, 
       100.0 * (s.total_amount - s.settled_amount) / NULLIF(s.total_amount, 0) AS level2_shortfall_pct, 
       CASE 
         WHEN s.settlement_id IS NULL THEN 'MISSING_SETTLEMENT' 
         WHEN t.txn_total IS NULL THEN 'MISSING_TRANSACTIONS' 
         WHEN ABS(t.txn_total - s.total_amount) <= 0.01 * s.total_amount THEN 'WITHIN_TOLERANCE' 
         ELSE 'MISMATCH' 
       END AS recon_status 
FROM settle s 
FULL OUTER JOIN txn_week t ON t.merchant_id = s.merchant_id AND t.batch_date = s.batch_date; 