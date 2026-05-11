# Full Stack Data Course - Movie Analytics Pipeline

Pipeline ELT (Extract, Load, Transform) construite durant le cours Full Stack Data Builder. Ce projet extrait des données de films depuis l'API TMDB, les transforme et les charge dans PostgreSQL pour visualisation dans Metabase.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   TMDB API  │────▶│   Python    │────▶│  PostgreSQL │────▶│  Metabase   │
│  (Extract)  │     │  (Clean)    │     │   (Load)    │     │ (Dashboard) │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

## Structure du Projet

```
├── movieDB_pipeline/       # Pipeline ELT principale
│   ├── main_pipeline.py    # Point d'entrée de la pipeline
│   ├── extraction.py       # Extraction des données TMDB
│   ├── cleaning.py         # Nettoyage et transformation
│   ├── load_data.py        # Chargement dans PostgreSQL
│   └── config.py           # Configuration et helpers API
│
├── orchestration/          # Scripts d'orchestration
│   ├── run_pipeline.sh     # Exécution de la pipeline complète
│   ├── health_check.sh     # Vérification de l'état des services
│   └── logs/               # Logs d'erreurs
│
├── Notebooks/              # Notebooks de développement
│   └── config_test.ipynb   # Tests et exploration initiale
│
├── SQL/                    # Exercices et cours SQL
│   ├── SQL_Fundamentals.sql
│   ├── AdvancedSQL.sql
│   ├── Automation.sql
│   ├── MaterializedView.sql
│   └── createTables.sql
│
├── dockers/                # Configuration Docker
├── cron_test/              # Tests de planification cron
└── utils/                  # Utilitaires
```

## Technologies

| Composant | Technologie |
|-----------|-------------|
| Langage | Python 3.14 |
| API Source | [TMDB](https://www.themoviedb.org/) |
| Base de données | PostgreSQL (Docker) |
| Visualisation | Metabase (Docker) |
| Orchestration | Bash / Cron |

## Pipeline ELT

### 1. Extraction (`extraction.py`)
- Récupère les films populaires via l'API TMDB
- Extrait les détails de chaque film (budget, revenue, runtime)
- Récupère les genres associés à chaque film

### 2. Nettoyage (`cleaning.py`)
- Suppression des doublons
- Filtrage des films sans titre
- Validation des données (vote_count > 5)
- Nettoyage des genres orphelins

### 3. Chargement (`load_data.py`)
- Connexion PostgreSQL via SQLAlchemy
- Suppression des anciennes données
- Insertion des nouvelles données dans `movies` et `movies_genres`

### 4. Rafraîchissement Dashboard
- Mise à jour de la vue matérialisée `movies_dashboard`

## Installation

### Prérequis
- Python 3.x
- Docker
- Compte TMDB (pour l'API key)

### Setup

1. **Cloner le repository**
```bash
git clone <repo-url>
cd kottiodev_elt
```

2. **Créer l'environnement virtuel**
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

3. **Configurer les variables d'environnement**
```bash
# Créer un fichier .env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=analytics_db
DB_USER=admin
DB_PASSWORD=<your_password>
MOVIE_DB_TOKEN=<your_tmdb_token>
```

4. **Lancer les containers Docker**
```bash
docker-compose up -d
```

## Utilisation

### Lancer la pipeline
```bash
./orchestration/run_pipeline.sh
```

### Vérifier l'état des services
```bash
./orchestration/health_check.sh
```

### Exécuter manuellement
```bash
source venv/bin/activate
python movieDB_pipeline/main_pipeline.py
```

## Dashboard

Le dashboard Metabase est accessible sur `http://localhost:3000` et affiche:
- Films populaires
- Distribution par genre
- Analyse budget/revenue
- Tendances de popularité

---

*Projet réalisé dans le cadre du cours Full Stack Data Builder*
