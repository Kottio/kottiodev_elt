-- Script de nettoyage post-ETL
-- À lancer après chaque import de données TMDB

-- 1. Recréer la vue clean (écrase l'ancienne)
CREATE VIEW movies_clean AS
SELECT *
FROM movies 
WHERE budget > 0 AND revenue > 0;

-- 2. Vérifier les nouvelles données
SELECT 
  COUNT(*) as total_films,
  COUNT(*) FILTER (WHERE budget > 0 AND revenue > 0) as films_clean,
  ROUND(
    (COUNT(*) FILTER (WHERE budget > 0 AND revenue > 0)::float / COUNT(*) * 100), 
    1
  ) as clean_percentage
FROM movies;


-- 3. Quick check
SELECT 'Vue mise à jour avec ' || COUNT(*) || ' films clean' as status
FROM movies_clean;

-- 4. Health Check 
SELECT 
  CASE 
    WHEN (COUNT(*) FILTER (WHERE budget > 0 AND revenue > 0))::float / COUNT(*) < 0.5 
    THEN '⚠️ ALERTE: Moins de 50% des films ont des données financières complètes'
    ELSE '✅ Qualité des données acceptable'
  END as data_health_status
FROM movies;





CREATE MATERIALIZED VIEW movies_clean_mat AS
SELECT id, title, budget, revenue
FROM movies 
WHERE budget > 0 AND revenue > 0;

-- À chaque fois qu'on fait ça :
SELECT * FROM movies_clean_mat;
-- → SQL lit directement les résultats STOCKÉS (rapide!)

-- Mais quand on ajoute de nouveaux films...
-- La vue NE SE MET PAS À JOUR automatiquement !
REFRESH MATERIALIZED VIEW movies_clean_mat;  -- ← Il faut faire ça



docker cp test.sql postgres:/test.sql
docker exec -it postgres psql -U admin -d analytics_db -f /test.sql
t-_

docker inspect postgres
docker volume list