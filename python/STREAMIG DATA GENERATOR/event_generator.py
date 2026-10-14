import json, random, time, uuid
from datetime import datetime, timedelta
from kafka import KafkaProducer          # pip install kafka-python
from sqlalchemy import create_engine, text
db_name = "ABC fintech"
engine = create_engine(f"postgresql+psycopg2://postgres:3668@localhost:5432/{db_name}")
with engine.connect() as c:
    customers = [r[0] for r in c.execute(text(
        "SELECT customer_id FROM gold.dim_customer WHERE customer_id IS NOT NULL"))]
    merchants = [r[0] for r in c.execute(text(
        "SELECT merchant_id FROM gold.dim_merchant WHERE merchant_id IS NOT NULL"))]

producer = KafkaProducer(bootstrap_servers="localhost:9092",
                         value_serializer=lambda v: json.dumps(v).encode())

def make_event(seq):
    channel = random.choices(["UPI", "WALLET", "GATEWAY"], [0.55, 0.25, 0.20])[0]
    return {
        "event_id": str(uuid.uuid4()),
        "transaction_id": f"TXS{seq:09d}",
        "channel": channel,
        "customer_id": None if channel == "GATEWAY" else random.choice(customers),
        "merchant_id": None if (channel == "WALLET" and random.random() < 0.3)
                       else random.choice(merchants),
        "amount": round(random.lognormvariate(6.2, 1.0), 2),
        "status": random.choices(["SUCCESS", "FAILED", "PENDING"], [0.88, 0.09, 0.03])[0],
        "event_ts": datetime.now().isoformat(timespec="seconds"),
    }

def inject_fault(ev):
    """~3% of events get a deliberate defect so silver has real cleansing work."""
    r = random.random()
    if r < 0.01:   return [ev, ev]                                   # duplicate delivery
    if r < 0.015:  ev["amount"] = None                               # null amount
    elif r < 0.02: ev["amount"] = -abs(ev["amount"])                 # negative amount
    elif r < 0.025: ev["status"] = ev["status"].lower()              # casing drift
    elif r < 0.03:  ev["event_ts"] = (datetime.now() - timedelta(hours=2)).isoformat(timespec="seconds")  # late event
    return [ev]

RATE_PER_SEC = 5
seq = 0
while True:
    seq += 1
    for e in inject_fault(make_event(seq)):
        producer.send("eftp.transactions", e)
    time.sleep(1 / RATE_PER_SEC)