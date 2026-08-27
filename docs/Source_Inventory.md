# EFTP — Source Inventory

**Project:** UC12 Enterprise FinTech Data Platform
**Sprint:** Sprint 1 — Data Discovery & Ingestion
**Purpose:** Catalog every enterprise source system feeding the platform, its format, volume, and ingestion path into the Bronze staging layer.

---

## Summary

| # | Source System | Format | File / Object | Volume | Staging Table |
|---|---|---|---|---|---|
| 1 | UPI Transaction System | CSV | `upi_transactions.csv` | 6,760 rows | `staging.upi_transactions` |
| 2 | Digital Wallet Platform | CSV | `digital_wallet_transactions.csv` | 2,954 rows | `staging.digital_wallet_transactions` |
| 3 | Payment Gateway | JSON | `payment_gateway_transactions.json` | 2,406 records | `staging.payment_gateway_transactions` |
| 4 | Merchant Portal | Excel (.xlsx) | `merchant_portal.xlsx` (sheet: Merchants) | 150 rows | `staging.merchant_portal` |
| 5 | Customer Relationship Management (CRM) | SQL (SQLite) | `crm_customers.db` (table: `customers`) | 1,980 rows | `staging.crm_customers` |
| 6 | KYC Verification System | JSON | `kyc_verification.json` | 2,000 records | `staging.kyc_verification` |
| 7 | Settlement Processing System | CSV | `settlement_batches.csv` | 3,864 rows | `staging.settlement_batches` |
| 8 | Mobile Banking Application | JSON | `mobile_banking_sessions.json` | 6,000 records | `staging.mobile_banking_sessions` |
| 9 | Fraud Detection System | CSV | `fraud_detection_flags.csv` | 970 rows | `staging.fraud_detection_flags` |
| 10 | API Gateway Logs | XML | `api_gateway_logs.xml` (`/logs/entry`) | 5,200 entries | `staging.api_gateway_logs` |

**Total raw records ingested in Sprint 1:** ~32,284

---

## 1. UPI Transaction System
- **Business purpose:** Records all customer payments made via UPI (Unified Payments Interface) across supported apps.
- **Format:** CSV
- **Location:** `datasets/upi_transactions.csv`
- **Ingestion tool:** Pentaho — CSV file input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_upi_transactions.ktr`
- **Key fields:** `transaction_id`, `customer_id`, `merchant_id`, `amount`, `status`, `upi_app`
- **Joins to:** CRM (customer_id), Merchant Portal (merchant_id), Fraud/Mobile Banking/API Logs (transaction_id)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** Null/negative amounts present; status field has inconsistent casing

## 2. Digital Wallet Platform
- **Business purpose:** Tracks wallet load, spend, and peer-to-peer transfer activity.
- **Format:** CSV
- **Location:** `datasets/digital_wallet_transactions.csv`
- **Ingestion tool:** Pentaho — CSV file input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_digital_wallet.ktr`
- **Key fields:** `wallet_txn_id`, `transaction_id`, `customer_id`, `merchant_id` (nullable), `txn_type`, `amount`
- **Joins to:** CRM (customer_id), Merchant Portal (merchant_id, where applicable)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** ~30% of P2P transfers have null merchant_id (expected); null amounts present

## 3. Payment Gateway
- **Business purpose:** Captures merchant-initiated transactions processed through the gateway (card, UPI, netbanking).
- **Format:** JSON
- **Location:** `datasets/payment_gateway_transactions.json`
- **Ingestion tool:** Pentaho — JSON Input (JSONPath-mapped fields) → Table Output
- **Transformation file:** `pentaho/transformations/ingest_payment_gateway.ktr`
- **Key fields:** `gateway_txn_id`, `transaction_id`, `merchant_id`, `payment_mode`, `gateway_status`, `response_code`
- **Joins to:** Merchant Portal (merchant_id)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** A small number of null amounts

## 4. Merchant Portal
- **Business purpose:** Master data for onboarded merchants — identity, category, settlement configuration.
- **Format:** Excel (.xlsx)
- **Location:** `datasets/merchant_portal.xlsx`
- **Ingestion tool:** Pentaho — Microsoft Excel Input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_merchant_portal.ktr`
- **Key fields:** `merchant_id`, `merchant_name`, `category`, `settlement_cycle`
- **Joins to:** all transaction sources, Settlement Processing System (merchant_id)
- **Refresh frequency (assumed):** Weekly / on merchant onboarding
- **Known data quality notes:** ~15% of merchant names have inconsistent casing

## 5. Customer Relationship Management (CRM)
- **Business purpose:** System of record for customer identity and profile data.
- **Format:** SQL (SQLite database)
- **Location:** `datasets/crm_customers.db` (table `customers`); convenience CSV export also provided as `crm_customers_export.csv`
- **Ingestion tool:** Pentaho — Table Input (SQLite JDBC connection) → Table Output
- **Transformation file:** `pentaho/transformations/ingest_crm.ktr`
- **Key fields:** `customer_id`, `name`, `city`, `state`, `customer_segment`
- **Joins to:** all customer-linked sources (customer_id)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** ~1% of customers referenced elsewhere are missing from this source (orphaned FK scenario)

## 6. KYC Verification System
- **Business purpose:** Regulatory identity verification status and risk scoring per customer.
- **Format:** JSON
- **Location:** `datasets/kyc_verification.json`
- **Ingestion tool:** Pentaho — JSON Input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_kyc.ktr`
- **Key fields:** `customer_id`, `kyc_status`, `risk_score`
- **Joins to:** CRM (customer_id, 1:1)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** `verification_date` null for PENDING records (expected)

## 7. Settlement Processing System
- **Business purpose:** Weekly settlement batches reconciling merchant payouts against processed transactions.
- **Format:** CSV
- **Location:** `datasets/settlement_batches.csv`
- **Ingestion tool:** Pentaho — CSV file input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_settlement.ktr`
- **Key fields:** `settlement_id`, `merchant_id`, `total_amount`, `settled_amount`, `settlement_status`
- **Joins to:** Merchant Portal (merchant_id)
- **Refresh frequency (assumed):** Weekly batch
- **Known data quality notes:** Some batches show variance between total_amount and settled_amount — feeds Sprint 3 reconciliation validation

## 8. Mobile Banking Application
- **Business purpose:** App-level session and activity logs for the customer-facing mobile banking app.
- **Format:** JSON
- **Location:** `datasets/mobile_banking_sessions.json`
- **Ingestion tool:** Pentaho — JSON Input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_mobile_banking.ktr`
- **Key fields:** `session_id`, `customer_id`, `transaction_id` (nullable), `action`
- **Joins to:** CRM (customer_id), transaction sources (transaction_id, where linked)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** ~15% of sessions have no linked transaction (browsing-only activity — expected)

## 9. Fraud Detection System
- **Business purpose:** Machine-learning-scored fraud assessment for a sampled subset of transactions.
- **Format:** CSV
- **Location:** `datasets/fraud_detection_flags.csv`
- **Ingestion tool:** Pentaho — CSV file input → Table Output
- **Transformation file:** `pentaho/transformations/ingest_fraud_detection.ktr`
- **Key fields:** `transaction_id`, `fraud_score`, `is_fraud`, `fraud_reason`
- **Joins to:** all transaction sources (transaction_id)
- **Refresh frequency (assumed):** Near real-time / daily batch
- **Known data quality notes:** Only ~8% of transactions are scored; `fraud_reason` populated only when flagged

## 10. API Gateway Logs
- **Business purpose:** Technical audit trail of all API calls across the platform's services.
- **Format:** XML
- **Location:** `datasets/api_gateway_logs.xml`
- **Ingestion tool:** Pentaho — Get Data From XML (Loop XPath: `/logs/entry`) → Table Output
- **Transformation file:** `pentaho/transformations/ingest_api_gateway_logs.ktr`
- **Key fields:** `request_id`, `transaction_id` (nullable), `endpoint`, `status_code`, `response_time_ms`
- **Joins to:** transaction sources (transaction_id, where present)
- **Refresh frequency (assumed):** Daily batch
- **Known data quality notes:** ~14% of entries are health-check/pre-transaction calls with no transaction_id (expected)

---

## Format Coverage Summary

| Format | Sources |
|---|---|
| CSV | UPI Transactions, Digital Wallet, Settlement Processing, Fraud Detection (4) |
| JSON | Payment Gateway, KYC Verification, Mobile Banking (3) |
| Excel | Merchant Portal (1) |
| SQL | CRM (1) |
| XML | API Gateway Logs (1) |

All five formats named in the project brief (CSV, Excel, JSON, XML, SQL) are represented, satisfying the Sprint 1 ingestion diversity requirement.
