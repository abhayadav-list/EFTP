import pandas as pd
from script1 import get_engine

engine = get_engine()

tables = [
    "upi_transactions", "digital_wallet_transactions", "payment_gateway_transactions",
    "merchant_portal", "crm_customers", "kyc_verification", "settlement_batches",
    "mobile_banking_sessions", "fraud_detection_flags", "api_gateway_logs",
]

dfs = {t: pd.read_sql(f"SELECT * FROM staging.{t}", engine) for t in tables}

for name, df in dfs.items():
    print(name, df.shape)