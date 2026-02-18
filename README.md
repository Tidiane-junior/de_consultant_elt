# 🚀 Data Engineer ELT Pipeline – Architecture Médaillon

## 📌 Objectif

Construire un pipeline ELT complet en Python et PostgreSQL en suivant l’architecture Médaillon :

- 🥉 Bronze : données brutes
- 🥈 Silver : données nettoyées et normalisées
- 🥇 Gold : données prêtes pour analyse métier

Projet réalisé dans une logique entreprise / consultant data engineer.

---

## 🏗 Architecture

    raw (CSV)
    ↓
    Bronze (PostgreSQL)
    ↓
    Silver (nettoyage SQL)
    ↓
    Gold (modèle analytique)

---

## 🛠 Stack Technique

- Python 3.x
- PostgreSQL
- psycopg2
- pandas
- VSCode
- Architecture ELT
- SQL transformation driven

---

## 📂 Structure du projet

    de_consultant_elt/
    │
    ├── raw/ # Fichiers CSV bruts
    │
    ├── sql/
    │ ├── bronze/
    │ ├── silver/ # Scripts SQL de transformation
    │ ├── gold/
    │
    ├── src/
    │ ├── load/ # Ingestion Bronze
    │ ├── transform/ # Orchestration SQL
    │ ├── utils/ # Connexion DB & outils
    │
    ├── config/
    ├── logs/
    │
    ├── main.py
    ├── .env
    ├── README.md


---

## 🥉 Bronze Layer

Objectif :
- Chargement brut des fichiers CSV
- Aucun nettoyage
- Tous les champs en TEXT
- Rechargement complet à chaque exécution

Script :

    python -m src.load.load_bronze


Tables créées :
- bronze.orders
- bronze.products
- bronze.customers

---

## 🥈 Silver Layer

Objectif :
- Suppression des doublons
- Nettoyage minimal
- Création d’index
- Préparation pour modélisation

Script :

    python -m src.transform.run_silver


---

## 🔄 Orchestration

Les transformations sont réalisées en SQL (ELT).

Python est utilisé pour :
- gérer la connexion
- exécuter les fichiers SQL
- gérer les transactions
- gérer les erreurs

---

## 🔐 Configuration

Créer un fichier `.env` à la racine :

    DB_HOST=localhost
    DB_PORT=5432
    DB_NAME=pipeline
    DB_USER=postgres
    DB_PASSWORD=xxxx


---

## 📈 Prochaines étapes

- Création de la couche Gold
- KPI business (CA, CLV, top produits)
- Data quality checks
- Idempotence avancée
- Ajout orchestration type Airflow
- Dockerisation
- CI/CD

---

## 🧠 Logique Médaillon

| Couche  | Objectif |
|----------|----------|
| Bronze  | Stocker le brut |
| Silver  | Nettoyer et structurer |
| Gold    | Modélisation métier |

---

## 🎯 Compétences démontrées

- Conception architecture data
- ELT PostgreSQL
- Python production-ready
- SQL transformation design
- Structuration projet type entreprise

---

## 📌 Auteur

Projet réalisé dans une logique de montée en compétences Data Engineer / Consultant.
