-- sql/backfill_gateway_customers.sql
-- Fills customer_sk for transactions that have no customer in their own source
-- (mainly gateway rows) using the customer on a linked mobile banking session.
-- Inference: the session user is assumed to be the payer. Safe to rerun.

UPDATE gold.fact_transactions f
SET customer_sk = c.customer_sk
FROM (
    SELECT DISTINCT ON (transaction_id) transaction_id, customer_id
    FROM silver.mobile_banking_sessions
    WHERE NULLIF(transaction_id, '') IS NOT NULL
    ORDER BY transaction_id, login_timestamp
) s
JOIN gold.dim_customer c ON c.customer_id = s.customer_id
WHERE f.transaction_id = s.transaction_id
  AND f.customer_sk IS NULL;