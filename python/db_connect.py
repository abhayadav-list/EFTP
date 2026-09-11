
from sqlalchemy import create_engine
def get_engine(schema='staging'):
    return create_engine("postgresql+psycopg://postgres:3668@localhost:5432/ABC fintech")