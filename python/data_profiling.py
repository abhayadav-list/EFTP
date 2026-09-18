from pathlib import Path

import pandas as pd
from script1 import get_engine
from ydata_profiling import ProfileReport

engine = get_engine()

tables = [
    "upi_transactions",
    "digital_wallet_transactions",
    "payment_gateway_transactions",
    "merchant_portal",
    "crm_customers",
    "kyc_verification",
    "settlement_batches",
    "mobile_banking_sessions", "fraud_detection_flags", "api_gateway_logs",
]

dfs = {t: pd.read_sql(f"SELECT * FROM staging.{t}", engine) for t in tables}

for name, df in dfs.items():
    print(name, df.shape)


def create_profile_reports():
    output_dir = Path("docs/profiling")
    output_dir.mkdir(parents=True, exist_ok=True)

    for name, df in dfs.items():
        profile = ProfileReport(df, title=f"{name} Profile", minimal=True)
        profile.to_file(output_dir / f"{name}_profile.html")


if __name__ == "__main__":
    create_profile_reports()


