# EFTP — Data Dictionary

**Project:** UC12 Enterprise FinTech Data Platform
**Scope:** All 10 source systems ingested in Sprint 1
**Values below are real samples pulled directly from the downloaded dataset files.**

---

## 1. UPI Transaction System
**File:** `upi_transactions.csv` | **Format:** CSV | **Rows:** 6,760 | **Target:** `staging.upi_transactions`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| transaction_id | String | Unique transaction identifier | `TXN0000001` | No | PK |
| customer_id | String | Customer initiating the payment | `CUST00026` | No | FK → CRM, KYC |
| merchant_id | String | Merchant receiving payment | `MER0075` | No | FK → Merchant Portal |
| upi_vpa | String | Customer's virtual payment address | `cust00026@okhdfcbank` | No | |
| amount | Decimal | Transaction amount (₹) | `350.63` | **Yes (37 rows)** | |
| timestamp | Datetime | Date/time of transaction | `2025-03-22 08:29:40` | No | |
| status | String | Transaction outcome | `Success` | No | Casing inconsistent (Success/SUCCESS/success) |
| bank_rrn | Integer | Bank Reference Retrieval Number | `403700826674` | No | |
| upi_app | String | UPI app used | `Amazon Pay` | No | |

---

## 2. Digital Wallet Platform
**File:** `digital_wallet_transactions.csv` | **Format:** CSV | **Rows:** 2,954 | **Target:** `staging.digital_wallet_transactions`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| wallet_txn_id | String | Unique wallet transaction ID | `WLT0000001` | No | PK |
| transaction_id | String | Cross-system transaction ID | `TXN0000003` | No | FK → fraud, mobile banking, API logs |
| customer_id | String | Wallet owner | `CUST01846` | No | FK → CRM, KYC |
| merchant_id | String | Merchant (blank for P2P transfers) | `MER0063` | **Yes (899 rows)** | FK → Merchant Portal |
| wallet_provider | String | Wallet service provider | `Mobikwik` | No | |
| txn_type | String | LOAD / SPEND / P2P_TRANSFER | `LOAD` | No | |
| amount | Decimal | Transaction amount (₹) | `469.10` | **Yes (13 rows)** | |
| wallet_balance_after | Decimal | Balance after transaction (₹) | `10899.61` | No | |
| timestamp | Datetime | Date/time of transaction | `2025-04-22 01:31:43` | No | |
| status | String | Transaction outcome | `Success` | No | Casing inconsistent |

---

## 3. Payment Gateway
**File:** `payment_gateway_transactions.json` | **Format:** JSON (array) | **Records:** 2,406 | **Target:** `staging.payment_gateway_transactions`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| gateway_txn_id | String | Gateway's internal transaction ID | `GTW94694643` | No | PK |
| transaction_id | String | Cross-system transaction ID | `TXN0000002` | No | FK |
| merchant_id | String | Merchant charged | `MER0022` | No | FK → Merchant Portal |
| amount | Decimal | Transaction amount (₹) | `3451.96` | **Yes (11 rows)** | |
| payment_mode | String | UPI / CARD / NETBANKING | `NETBANKING` | No | |
| gateway_status | String | Gateway-reported status | `SUCCESS` | No | |
| response_code | String | HTTP-style response code | `200` | No | |
| timestamp | Datetime (ISO 8601) | Date/time of transaction | `2025-05-21T18:01:01` | No | |

---

## 4. Merchant Portal
**File:** `merchant_portal.xlsx` (sheet: **Merchants**) | **Format:** Excel | **Rows:** 150 | **Target:** `staging.merchant_portal`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| merchant_id | String | Unique merchant identifier | `MER0001` | No | PK |
| merchant_name | String | Registered business name | `Bhatti LLC` | No | ~15% inconsistent casing |
| category | String | Merchant business category | `Fuel` | No | |
| city | String | Merchant city | `Barasat` | No | |
| state | String | Merchant state | `Uttarakhand` | No | |
| onboarding_date | Date | Date merchant joined platform | `2023-10-24` | No | |
| gst_number | String | GST registration number | `14XVQNIVI377E8Z0` | No | |
| bank_account | String | Settlement bank account number | `PAVE6049769799872` | No | |
| settlement_cycle | String | T+1 / T+2 / Weekly | `Weekly` | No | |

---

## 5. Customer Relationship Management (CRM)
**File:** `crm_customers.db` (table: `customers`), also `crm_customers_export.csv` | **Format:** SQL (SQLite) | **Rows:** 1,980 | **Target:** `staging.crm_customers`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| customer_id | String | Unique customer identifier | `CUST00001` | No | PK |
| name | String | Customer full name | `Aryan Maharaj` | No | |
| gender | String | M / F | `M` | No | |
| dob | Date | Date of birth | `1972-05-22` | No | |
| phone | Integer | 10-digit mobile number | `1819600133` | No | |
| email | String | Email address | `onikannan@example.com` | No | |
| city | String | Customer city | `Chennai` | No | |
| state | String | Customer state | `Tripura` | No | |
| signup_date | Date | Platform signup date | `2025-12-25` | No | |
| customer_segment | String | Retail / Premium / Merchant-linked | `Retail` | No | |
| support_tickets_count | Integer | Historical support ticket count | `2` | No | |

**Note:** ~1% of customer_ids referenced in transaction sources do not appear here — an intentional missing-record scenario for Sprint 2 profiling.

---

## 6. KYC Verification System
**File:** `kyc_verification.json` | **Format:** JSON (array) | **Records:** 2,000 | **Target:** `staging.kyc_verification`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| customer_id | String | Customer being verified | `CUST00001` | No | FK → CRM (1:1) |
| kyc_status | String | VERIFIED / PENDING / REJECTED | `VERIFIED` | No | |
| id_type | String | ID document type | `Passport` | No | |
| verification_date | Date | Date KYC was completed | `2025-05-19` | **Yes (208 rows — PENDING records)** | |
| risk_score | Decimal (0–1) | Model-assigned risk score | `0.324` | No | |

---

## 7. Settlement Processing System
**File:** `settlement_batches.csv` | **Format:** CSV | **Rows:** 3,864 | **Target:** `staging.settlement_batches`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| settlement_id | String | Unique settlement batch ID | `SET000001` | No | PK |
| merchant_id | String | Merchant being settled | `MER0001` | No | FK → Merchant Portal |
| batch_date | Date | Weekly settlement batch date | `2025-01-05` | No | |
| total_transactions | Integer | Transactions in this batch | `2` | No | |
| total_amount | Decimal | Sum of transaction amounts (₹) | `267.68` | No | |
| settled_amount | Decimal | Amount actually settled (₹) | `265.36` | No | May differ from total_amount |
| settlement_status | String | MATCHED / VARIANCE | `VARIANCE` | No | Reconciliation target (Sprint 3) |

---

## 8. Mobile Banking Application
**File:** `mobile_banking_sessions.json` | **Format:** JSON (array) | **Records:** 6,000 | **Target:** `staging.mobile_banking_sessions`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| session_id | String | Unique app session ID | `SESS0000001` | No | PK |
| customer_id | String | Customer using the app | `CUST01975` | No | FK → CRM |
| transaction_id | String | Linked transaction, if any | `TXN0004884` | **Yes (926 rows — browsing-only sessions)** | FK |
| device_type | String | Android / iOS | `Android` | No | |
| os_version | String | Device OS version | `12.7` | No | |
| app_version | String | Mobile app version | `3.2.3` | No | |
| login_timestamp | Datetime (ISO 8601) | Session start time | `2025-01-12T00:07:08` | No | |
| action | String | Action performed in session | `QR_SCAN` | No | |

---

## 9. Fraud Detection System
**File:** `fraud_detection_flags.csv` | **Format:** CSV | **Rows:** 970 | **Target:** `staging.fraud_detection_flags`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| transaction_id | String | Transaction that was scored | `TXN0002697` | No | FK |
| fraud_score | Decimal (0–1) | Model-assigned fraud probability | `0.126` | No | |
| is_fraud | Integer (0/1) | Final fraud flag | `0` | No | |
| fraud_reason | String | Reason code if flagged | `VELOCITY_CHECK` | **Yes (968 rows — only flagged txns have a reason)** | |
| model_version | String | Fraud model version used | `fraud-model-v2.3` | No | |
| flagged_timestamp | Datetime | Time transaction was scored | `2025-03-29 01:06:32` | No | |

**Note:** Only ~8% of all transactions are scored — a transaction with no row here simply wasn't sampled for fraud scoring, not an error.

---

## 10. API Gateway Logs
**File:** `api_gateway_logs.xml` | **Format:** XML | **Entries:** 5,200 (`/logs/entry`) | **Target:** `staging.api_gateway_logs`

| Field | Data Type | Description | Sample Value | Nullable | Key |
|---|---|---|---|---|---|
| request_id | String | Unique API request ID | `REQ0000001` | No | PK |
| transaction_id | String | Linked transaction, if applicable | `TXN0002129` | **Yes (714 rows — health checks/failed pre-txn calls)** | FK |
| endpoint | String | API endpoint called | `/api/v1/gateway/charge` | No | |
| http_method | String | HTTP verb | `POST` | No | |
| status_code | String | HTTP response code | `200` | No | |
| response_time_ms | Integer | API response time (ms) | `633` | No | |
| timestamp | Datetime (ISO 8601) | Time of the API call | `2025-02-19T11:44:04` | No | |
| client_ip | String | Originating client IP | `156.129.23.162` | No | |

---

## Cross-Source Join Keys (for Sprint 2 Star Schema)

| Key | Appears In |
|---|---|
| `transaction_id` | upi_transactions, digital_wallet_transactions, payment_gateway_transactions, mobile_banking_sessions, fraud_detection_flags, api_gateway_logs |
| `customer_id` | upi_transactions, digital_wallet_transactions, crm_customers, kyc_verification, mobile_banking_sessions |
| `merchant_id` | upi_transactions, digital_wallet_transactions, payment_gateway_transactions, merchant_portal, settlement_batches |

## Known Data Quality Issues (for Sprint 2 Data Quality Report)

- Null/negative amounts in upi_transactions, digital_wallet_transactions, payment_gateway_transactions
- Inconsistent status casing (Success/SUCCESS/success) across all three transaction sources
- ~15% inconsistent merchant_name casing in merchant_portal
- ~1% of customer_ids present in transactions but absent from crm_customers (orphaned FK)
- Duplicate transaction rows (~1% of combined transaction sources)
- settlement_batches: total_amount vs settled_amount variance on some batches
