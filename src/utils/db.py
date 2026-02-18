import os
import psycopg2
from dotenv import load_dotenv

# Charge les variables d'environnement depuis .env
load_dotenv()

def get_connection():
    """
    Retourne une connexion PostgreSQL.
    Pattern entreprise : credentials dans .env, pas dans le code.
    """
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )