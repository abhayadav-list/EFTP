CREATE TABLE staging.upi_transactions (
    transaction_id TEXT, customer_id TEXT, merchant_id TEXT, upi_vpa TEXT,
    amount TEXT, txn_timestamp TEXT, status TEXT, bank_rrn TEXT, upi_app TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.digital_wallet_transactions (
    wallet_txn_id TEXT, transaction_id TEXT, customer_id TEXT, merchant_id TEXT,
    wallet_provider TEXT, txn_type TEXT, amount TEXT, wallet_balance_after TEXT,
    txn_timestamp TEXT, status TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.payment_gateway_transactions (
    gateway_txn_id TEXT, transaction_id TEXT, merchant_id TEXT, amount TEXT,
    payment_mode TEXT, gateway_status TEXT, response_code TEXT, txn_timestamp TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.merchant_portal (
    merchant_id TEXT, merchant_name TEXT, category TEXT, city TEXT, state TEXT,
    onboarding_date TEXT, gst_number TEXT, bank_account TEXT, settlement_cycle TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.crm_customers (
    customer_id TEXT, name TEXT, gender TEXT, dob TEXT, phone TEXT, email TEXT,
    city TEXT, state TEXT, signup_date TEXT, customer_segment TEXT, support_tickets_count TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.kyc_verification (
    customer_id TEXT, kyc_status TEXT, id_type TEXT, verification_date TEXT, risk_score TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.settlement_batches (
    settlement_id TEXT, merchant_id TEXT, batch_date TEXT, total_transactions TEXT,
    total_amount TEXT, settled_amount TEXT, settlement_status TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.mobile_banking_sessions (
    session_id TEXT, customer_id TEXT, transaction_id TEXT, device_type TEXT,
    os_version TEXT, app_version TEXT, login_timestamp TEXT, action TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.fraud_detection_flags (
    transaction_id TEXT, fraud_score TEXT, is_fraud TEXT, fraud_reason TEXT,
    model_version TEXT, flagged_timestamp TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);

CREATE TABLE staging.api_gateway_logs (
    request_id TEXT, transaction_id TEXT, endpoint TEXT, http_method TEXT,
    status_code TEXT, response_time_ms TEXT, log_timestamp TEXT, client_ip TEXT,
    source_system TEXT, load_timestamp TIMESTAMP, batch_id TEXT
);