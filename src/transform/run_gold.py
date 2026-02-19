from src.transform.run_sql_transform import run_sql_folder

def run_gold():
    """
    Exécute toutes les transformations GOLD (tables métier + KPI).
    """
    run_sql_folder("sql/gold")

if __name__ == "__main__":
    run_gold()