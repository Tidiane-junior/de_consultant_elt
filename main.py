from src.utils.db import get_connection

def test_db_connection():
    """
    Petit test rapide : on se connecte et on vérifie la base courante.
    """
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT current_database();")
    db_name = cur.fetchone()[0]
    cur.close()
    conn.close()

    print(f"✅ Connecter à la base : {db_name}")

if __name__ == "__main__":
    test_db_connection()