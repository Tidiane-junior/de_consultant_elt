from src.transform.run_sql_transform import run_sql_folder

def run_silver():
    """
    Exécute toutes les transformations Silver (SQL) dans l'ordre.
    """
    run_sql_folder("sql/silver")

if __name__ == "__main__":
    run_silver()