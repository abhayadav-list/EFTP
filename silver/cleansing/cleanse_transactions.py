from data_profiling import dfs, engine
import pandas as pd

# Apply fixes directly to the pandas frames


def clean_transaction_df(df, status_column="status"):
    df = df.copy()
    df[status_column] = df[status_column].str.upper()
    df["amount"] = pd.to_numeric(df["amount"], errors="coerce")
    df = df.drop_duplicates(subset=["transaction_id"], keep="first")
    df = df[
        df["amount"].notna() & (df["amount"] > 0)
    ]  # drop nulls & negatives, log separately first
    return df


upi_clean = clean_transaction_df(dfs["upi_transactions"])
wallet_clean = clean_transaction_df(dfs["digital_wallet_transactions"])
gateway_clean = clean_transaction_df(
    dfs["payment_gateway_transactions"], status_column="gateway_status"
)

merch_clean = dfs["merchant_portal"].copy()
merch_clean["merchant_name"] = merch_clean["merchant_name"].str.title()

crm_clean = dfs["crm_customers"].copy()
# Create the silver tables from the cleansed data.
upi_clean.to_sql(
    "upi_transactions",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
wallet_clean.to_sql(
    "digital_wallet_transactions",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
gateway_clean.to_sql(
    "payment_gateway_transactions",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
merch_clean.to_sql(
    "merchant_portal",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
crm_clean.to_sql(
    "crm_customers", engine, schema="silver", if_exists="replace", index=False
)
dfs["kyc_verification"].to_sql(
    "kyc_verification",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
dfs["fraud_detection_flags"].to_sql(
    "fraud_detection_flags",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
dfs["settlement_batches"].to_sql(
    "settlement_batches",
    engine,
    schema="silver",
    if_exists="replace",
    index=False,
)
