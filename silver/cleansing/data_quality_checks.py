from data_profiling import dfs
import pandas as pd
#Duplicate transactions
for name in ["upi_transactions", "digital_wallet_transactions", "payment_gateway_transactions"]:
    dupes = dfs[name][dfs[name].duplicated(subset=["transaction_id"], keep=False)]
    print(f"{name}: {dupes['transaction_id'].nunique()} duplicated transaction_ids, {len(dupes)} affected rows")

#Missing customer records — customers referenced in transactions but absent from CRM:
txn_customers = pd.concat([
    dfs["upi_transactions"]["customer_id"],
    dfs["digital_wallet_transactions"]["customer_id"],
]).unique()

crm_customers = set(dfs["crm_customers"]["customer_id"])
missing = [c for c in txn_customers if c not in crm_customers]
print(f"Missing customer records: {len(missing)}")

# Invalid / inconsistent payment statuses

for name in ["upi_transactions", "digital_wallet_transactions"]:
    print(name, "status variants:", dfs[name]["status"].unique())

#Inconsistent merchant information
merch = dfs["merchant_portal"]
inconsistent = merch[merch["merchant_name"] != merch["merchant_name"].str.title()]
print(f"Merchants with non-standard name casing: {len(inconsistent)} / {len(merch)}")


#checking for nulls 
for name in ["upi_transactions", "digital_wallet_transactions", "payment_gateway_transactions"]:
    print(name, "null amounts:", dfs[name]["amount"].isna().sum())
    print(name, "negative amounts:", (pd.to_numeric(dfs[name]["amount"], errors="coerce") < 0).sum())