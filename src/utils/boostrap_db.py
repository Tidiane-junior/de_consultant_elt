from src.utils.db import get_connection

SCHEMAS = ["bronze", "silver", "gold"]

def create_schemas():
    """
    On crée les schémas de l'architecture Médaillon dans PostgreSQL.
    Relançable sans erreur grâce au IF NOT EXISTS.
    """
    conn = get_connection()
    cur = conn.cursor()

    try:
        for schema in SCHEMAS:
            cur.execute(f"CREATE SCHEMA IF NOT EXISTS {schema};")

        conn.commit()
        print("✅ Schémas créés/confirmés :", ", ".join(SCHEMAS))

    except Exception as e:
        conn.rollback()
        print("❌ Erreur pendant la création des schémas :", e)
        raise

    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    create_schemas()