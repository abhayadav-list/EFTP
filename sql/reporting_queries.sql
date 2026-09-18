-- Success rate by channel
SELECT c.channel_name,
       ROUND(100.0 * SUM(CASE WHEN f.status='SUCCESS' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate_pct
FROM gold.fact_transactions f
JOIN gold.dim_channel c ON f.channel_sk = c.channel_sk
GROUP BY c.channel_name;

-- Top 10 merchants by transaction value
SELECT m.merchant_name, SUM(f.amount) AS total_value
FROM gold.fact_transactions f
JOIN gold.dim_merchant m ON f.merchant_sk = m.merchant_sk
GROUP BY m.merchant_name
ORDER BY total_value DESC
LIMIT 10;

-- Daily fraud rate
SELECT d.full_date,
       ROUND(100.0 * SUM(f.is_fraud) / COUNT(*), 3) AS fraud_rate_pct
FROM gold.fact_transactions f
JOIN gold.dim_date d ON f.date_sk = d.date_sk
GROUP BY d.full_date
ORDER BY d.full_date;