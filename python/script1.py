import pandas as pd
from sqlalchemy import create_engine

# Create a connection to the database
DB_USER = 'postgres'
DB_PASSWORD = 3668
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'ABC fintech'

def get_engine():
    conn_str = f'postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
    engine = create_engine(conn_str)
    print("Connection to the database established successfully.")
    return engine
