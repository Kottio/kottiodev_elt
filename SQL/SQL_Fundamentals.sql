-- Top 5 most popular films
SELECT title, popularity, vote_average 
FROM movies 
ORDER BY popularity DESC 
LIMIT 5;


-- Films rentables (revenue > budget)
SELECT title, budget, revenue, (revenue - budget) as profit
FROM movies 
WHERE revenue < budget AND revenue > 0 
ORDER BY profit;



-- Films récents avec bonne note
SELECT title, release_date, vote_average
FROM movies 
WHERE release_date > '2025-01-01' 
  AND vote_average > 7.0
ORDER BY vote_average DESC;

-- Statistiques générales
SELECT 
  COUNT(*) as total_films,
  ROUND(AVG(vote_average), 2 ) as note_moyenne,
  ROUND(AVG(budget),0) as budget_moyen
FROM movies
WHERE revenue > 0 AND budget > 0 

-- Films par langue
SELECT 
  original_language,
  COUNT(*) as nb_films,
  AVG(vote_average) as note_moyenne
FROM movies
GROUP BY original_language
ORDER BY nb_films DESC;


-- ROI Analysis
SELECT 
  CASE 
    WHEN budget > 100000000 THEN 'Blockbuster'
    WHEN budget > 30000000 THEN 'Big Budget'
    ELSE 'Small Budget'
  END as budget_category,
  COUNT(*) as nb_films,
  AVG(revenue::float / NULLIF(budget, 0)) as avg_roi
FROM movies
WHERE budget > 0
GROUP BY budget_category


-- Films et leurs genres
SELECT m.title, mg.genre
FROM movies m
JOIN movies_genres mg ON m.id = mg.movie_id
WHERE m.title = 'Mercy';


-- Genres les plus fréquents
SELECT 
  mg.genre,
  COUNT(*) as nb_films,
  AVG(m.vote_average) as note_moyenne,
  AVG(m.budget) as budget_moyen
FROM movies_genres mg
JOIN movies m ON mg.movie_id = m.id
GROUP BY mg.genre
ORDER BY nb_films DESC;

-- Top genres par revenus
SELECT 
  mg.genre,
  COUNT(*) as nb_films,
  SUM(m.revenue) as revenus_totaux,
  AVG(m.revenue) as revenu_moyen
FROM movies_genres mg
JOIN movies m ON mg.movie_id = m.id
WHERE m.revenue > 0
GROUP BY mg.genre
ORDER BY revenus_totaux DESC
LIMIT 5;

-- Films Science Fiction les plus rentables
SELECT 
  m.title,
  m.budget,
  m.revenue,
  (m.revenue::float / m.budget) as roi
FROM movies m
JOIN movies_genres mg ON m.id = mg.movie_id
WHERE mg.genre = 'Science Fiction'
  AND m.budget > 0
  AND m.revenue > 0
ORDER BY roi DESC
LIMIT 5;

