from dotenv import load_dotenv
import os
import psycopg2

load_dotenv()

def get_db_conn():
    try:
        conn =psycopg2.connect(
            host = os.getenv("DB_HOST"),
            port = os.getenv("DB_PORT"),
            dbname = os.getenv("DB_NAME"),
            user = os.getenv("DB_USER"),
            password = os.getenv("DB_PASSWORD")
        )
        print("Connected to db")
        return conn
        
    except psycopg2.OperationalError as error:
        print(f'Could not connect because: {error}')
        return None

def test():
    print("Hello Terst working")



