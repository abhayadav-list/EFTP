import os

from sqlalchemy import URL, create_engine, text

DB_USER = os.environ.get("DB_USER", "postgres")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "3668")
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = int(os.environ.get("DB_PORT", "5432"))
DB_NAME = os.environ.get("DB_NAME", "ABC fintech")

engine = create_engine(
    URL.create(
        "postgresql+psycopg2",
        username=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
    )
)

def scalar(sql):
    with engine.connect() as c:
        return c.execute(text(sql)).scalar()

def test_fact_matches_silver():
    fact = scalar("SELECT COUNT(*) FROM gold.fact_transactions")
    silver = scalar("""SELECT (SELECT COUNT(*) FROM silver.upi_transactions)
                            + (SELECT COUNT(*) FROM silver.digital_wallet_transactions)
                            + (SELECT COUNT(*) FROM silver.payment_gateway_transactions)""")
    assert fact == silver

def test_no_duplicate_transactions():
    assert scalar("SELECT COUNT(*) - COUNT(DISTINCT transaction_id) FROM gold.fact_transactions") == 0

def test_valid_statuses():
    assert scalar("SELECT COUNT(*) FROM gold.fact_transactions WHERE status NOT IN ('SUCCESS','FAILED','PENDING')") == 0

def test_no_bad_amounts():
    assert scalar("SELECT COUNT(*) FROM gold.fact_transactions WHERE amount IS NULL OR amount < 0") == 0

def test_no_missing_settlement_weeks():
    assert scalar("SELECT COUNT(*) FROM gold.reconciliation_result WHERE recon_status LIKE 'MISSING%'") == 0