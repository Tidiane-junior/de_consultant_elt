import os
import pandas as pd
from psycopg2.extras import execute_values

from src.utils.db import get_connection

RAW_DIR = "raw"

FILES = {
    "orders": os.path.join(RAW_DIR, "orders.csv"),
    "products": os.path.join(RAW_DIR, "products.csv"),
    "customers": os.path.join(RAW_DIR, "customers.csv"),
}

def _create_table_from_dataframe(cur, schema: str, table: str, df: pd.DataFrame):
    """
    Crée une table (schema.table) en fonction des colonnes du DataFrame.
    Choix volontaire pour Bronze : tout en TEXT pour respecter le brut.
    (Les types propres viendront en Silver)
    """
    cols_sql = ",\n".join([f'"{c}" TEXT' for c in df.columns])

    cur.execute(f'CREATE SCHEMA IF NOT EXISTS {schema};')
    cur.execute(f'DROP TABLE IF EXISTS {schema}."{table}";')  # Bronze = reload complet
    cur.execute(f"""
        CREATE TABLE {schema}."{table}" (
            {cols_sql}
        );
    """)

def _load_dataframe(cur, schema: str, table: str, df: pd.DataFrame, batch_size: int = 5000):
    """
    Charge un DataFrame dans une table PostgreSQL via insert bulk.
    """
    columns = [f'"{c}"' for c in df.columns]
    col_list = ", ".join(columns)

    # Remplace NaN par None (sinon insertion foireuse)
    df = df.where(pd.notnull(df), None)

    rows = df.values.tolist()

    for i in range(0, len(rows), batch_size):
        chunk = rows[i:i + batch_size]
        execute_values(
            cur,
            f'INSERT INTO {schema}."{table}" ({col_list}) VALUES %s',
            chunk
        )

def load_one_csv_to_bronze(table_name: str, file_path: str):
    """
    Pipeline Bronze pour 1 fichier : read CSV -> create table -> bulk insert.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Fichier introuvable: {file_path}")

    # dtype=str pour forcer le brut en texte, keep_default_na pour gérer les vides
    df = pd.read_csv(file_path, dtype=str, keep_default_na=True)

    conn = get_connection()
    cur = conn.cursor()

    try:
        _create_table_from_dataframe(cur, "bronze", table_name, df)
        _load_dataframe(cur, "bronze", table_name, df)

        conn.commit()
        print(f"✅ Chargé bronze.{table_name} | lignes: {len(df)} | colonnes: {len(df.columns)}")

    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur chargement bronze.{table_name} :", e)
        raise

    finally:
        cur.close()
        conn.close()

def load_all_bronze():
    """
    Charge orders, products, customers dans la couche Bronze.
    """
    for table, path in FILES.items():
        load_one_csv_to_bronze(table, path)

if __name__ == "__main__":
    load_all_bronze()