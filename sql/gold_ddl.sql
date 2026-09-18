CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE gold.dim_date (
    date_sk INT PRIMARY KEY,        -- yyyymmdd
    full_date DATE,
    day INT, month INT, month_name TEXT,
    quarter INT, year INT,
    day_of_week TEXT, is_weekend BOOLEAN
);

CREATE TABLE gold.dim_channel (
    channel_sk SERIAL PRIMARY KEY,
    channel_name TEXT UNIQUE
);

CREATE TABLE gold.dim_customer (
    customer_sk SERIAL PRIMARY KEY,
    customer_id TEXT UNIQUE,
    name TEXT, gender TEXT, city TEXT, state TEXT,
    customer_segment TEXT, kyc_status TEXT, risk_score NUMERIC,
    load_date TIMESTAMP DEFAULT now()
);

CREATE TABLE gold.dim_merchant (
    merchant_sk SERIAL PRIMARY KEY,
    merchant_id TEXT UNIQUE,
    merchant_name TEXT, category TEXT, city TEXT, state TEXT,
    settlement_cycle TEXT,
    load_date TIMESTAMP DEFAULT now()
);

CREATE TABLE gold.fact_transactions (
    transaction_sk SERIAL PRIMARY KEY,
    transaction_id TEXT UNIQUE,
    customer_sk INT REFERENCES gold.dim_customer(customer_sk),
    merchant_sk INT REFERENCES gold.dim_merchant(merchant_sk),
    date_sk INT REFERENCES gold.dim_date(date_sk),
    channel_sk INT REFERENCES gold.dim_channel(channel_sk),
    amount NUMERIC,
    status TEXT,
    is_fraud INT,
    fraud_score NUMERIC,
    load_date TIMESTAMP DEFAULT now()
);

CREATE TABLE gold.fact_settlement (
    settlement_sk SERIAL PRIMARY KEY,
    settlement_id TEXT UNIQUE,
    merchant_sk INT REFERENCES gold.dim_merchant(merchant_sk),
    date_sk INT REFERENCES gold.dim_date(date_sk),
    total_transactions INT,
    total_amount NUMERIC,
    settled_amount NUMERIC,
    settlement_status TEXT
);