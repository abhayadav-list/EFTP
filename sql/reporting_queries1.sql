----reporting queries---
---showing that warehouse is working--

-- Q1. Success rate by channel
SELECT ch.channel_name,
       COUNT(*) AS total_txns,
       ROUND(100.0 * SUM(CASE WHEN f.status = 'SUCCESS' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate_pct
FROM gold.fact_transactions f
JOIN gold.dim_channel ch ON ch.channel_sk = f.channel_sk
GROUP BY ch.channel_name
ORDER BY total_txns DESC;

-- Q2. Monthly transaction volume and value (successful only)
SELECT d.year, d.month, d.month_name,
       COUNT(*) AS txns, ROUND(SUM(f.amount), 2) AS total_value
FROM gold.fact_transactions f
JOIN gold.dim_date d ON d.date_sk = f.date_sk
WHERE f.status = 'SUCCESS'
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- Q3. Top 10 merchants by successful transaction value
SELECT m.merchant_id, m.merchant_name, m.category,
       COUNT(*) AS txns, ROUND(SUM(f.amount), 2) AS total_value
FROM gold.fact_transactions f
JOIN gold.dim_merchant m ON m.merchant_sk = f.merchant_sk
WHERE f.status = 'SUCCESS'
GROUP BY m.merchant_id, m.merchant_name, m.category
ORDER BY total_value DESC
LIMIT 10;

-- Q4. Performance by merchant category
SELECT m.category, COUNT(*) AS txns, ROUND(AVG(f.amount), 2) AS avg_ticket,
       ROUND(100.0 * SUM(CASE WHEN f.status = 'FAILED' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct
FROM gold.fact_transactions f
JOIN gold.dim_merchant m ON m.merchant_sk = f.merchant_sk
GROUP BY m.category
ORDER BY txns DESC;

-- Q5. Customer behavior by segment (LEFT JOIN keeps gateway/orphan rows as 'Unknown')
SELECT COALESCE(c.customer_segment, 'Unknown') AS segment,
       COUNT(*) AS txns, ROUND(AVG(f.amount), 2) AS avg_ticket
FROM gold.fact_transactions f
LEFT JOIN gold.dim_customer c ON c.customer_sk = f.customer_sk
GROUP BY COALESCE(c.customer_segment, 'Unknown')
ORDER BY txns DESC;

-- Q6. Fraud rate by month, among scored transactions only
SELECT d.month, d.month_name,
       COUNT(f.is_fraud) AS scored_txns,
       SUM(f.is_fraud)   AS flagged,
       ROUND(100.0 * SUM(f.is_fraud) / NULLIF(COUNT(f.is_fraud), 0), 2) AS fraud_rate_pct
FROM gold.fact_transactions f
JOIN gold.dim_date d ON d.date_sk = f.date_sk
GROUP BY d.month, d.month_name
ORDER BY d.month;

-- Q7. KYC status vs transaction activity
SELECT c.kyc_status, COUNT(*) AS txns, ROUND(SUM(f.amount), 2) AS total_value
FROM gold.fact_transactions f
JOIN gold.dim_customer c ON c.customer_sk = f.customer_sk
GROUP BY c.kyc_status;

-- Q8. Settlement shortfall distribution
SELECT CASE
         WHEN shortfall_pct < 0.5 THEN '0 - 0.5%'
         WHEN shortfall_pct < 1.0 THEN '0.5 - 1%'
         WHEN shortfall_pct < 2.0 THEN '1 - 2%'
         ELSE '2%+'
       END AS shortfall_band,
       COUNT(*) AS batches
FROM (
    SELECT 100.0 * (total_amount - settled_amount) / NULLIF(total_amount, 0) AS shortfall_pct
    FROM gold.fact_stellement
) s
GROUP BY 1
ORDER BY 1;