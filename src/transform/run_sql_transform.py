import os
from pathlib import Path
from src.utils.db import get_connection

def run_sql_file(cursor, file_path: Path):
    """
    Exécute un fichier SQL complet.
    - Supporte des scripts multi-lignes
    - Log le nom du fichier
    """
    sql = file_path.read_text(encoding="utf-8")
    cursor.execute(sql)
    print(f"✅ SQL exécuté : {file_path.name}")

def run_sql_folder(folder_path: str):
    """
    Exécute tous les fichiers .sql d'un dossier, triés par nom.
    Bon pattern : 01_*, 02_*, etc.
    """
    folder = Path(folder_path)
    sql_files = sorted(folder.glob("*.sql"))

    if not sql_files:
        raise FileNotFoundError(f"Aucun fichier .sql trouvé dans {folder_path}")

    conn = get_connection()
    cur = conn.cursor()

    try:
        for f in sql_files:
            run_sql_file(cur, f)
        conn.commit()
        print(f"🎉 Dossier exécuté avec succès : {folder_path}")

    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur SQL dans {folder_path} : {e}")
        raise

    finally:
        cur.close()
        conn.close()