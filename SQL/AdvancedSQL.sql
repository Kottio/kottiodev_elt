

-- Films rentables seulement : WITH 
WITH movies_profit AS (
	SELECT 
	title, 
	budget, 
	revenue,
	revenue - budget as profit 
	FROM movies 
	WHERE revenue >0 AND budget > 0 
	ORDER BY profit DESC) 
	
SELECT * FROM movies_profit WHERE profit > 0 


-- Revenues moyen par genre : WINDOWS FUNCTION

WITH avg_genre_rev AS(
SELECT m.title, m.revenue, mg.genre,
ROUND(AVG(m.revenue) 
OVER(PARTITION BY mg.genre),0) as avg_revenue_genre
FROM movies m
JOIN movies_genres mg 
ON mg.movie_id = m.id
WHERE revenue >0 
ORDER BY revenue DESC) 

SELECT title, genre, revenue - avg_revenue_genre as diff_avg_revenue
FROM avg_genre_rev
order by diff_avg_revenue desc

-- Ranking par revenue
SELECT title, revenue,original_language,
RANK() OVER (PARTITION BY original_language ORDER BY revenue DESC ) as Language_rank
FROM movies 
ORDER by Language_rank


-- Top films par genre
WITH genre_rank_all_movies AS (SELECT title, revenue, genre,
ROW_NUMBER() OVER(PARTITION BY genre ORDER BY revenue DESC) as genre_rank
FROM movies m 
JOIN movies_genres mg 
ON mg.movie_id = m.id
WHERE revenue >0 
)
SELECT * FROM genre_rank_all_movies
WHERE genre_rank <=2


-- Films au-dessus de la moyenne : SUBQUERY

SELECT title, 
revenue 
FROM movies
WHERE revenue >0 
AND revenue > (SELECT AVG(revenue) FROM movies
WHERE revenue >0  )


-- Genres des films les plus rentables
SELECT title 
FROM movies 
WHERE id IN (
SELECT id FROM movies WHERE revenue > 100000000
)

















-- Films rentables seulement
WITH profitable_movies AS (
  SELECT title, budget, revenue, 
         (revenue::float / budget) as roi
  FROM movies 
  WHERE budget > 0 AND revenue > 0
)
SELECT title, budget, revenue, roi
FROM profitable_movies
WHERE roi > 2.0
ORDER BY roi DESC;

-- Revenues moyen par genre & revenues de chaque films

SELECT title,
revenue, 
genre,
ROUND(AVG(revenue) OVER (PARTITION BY mg.genre),0) as Avg_genre_revenues
FROM movies m
JOIN movies_genres mg on mg.movie_id = m.id
WHERE revenue > 0 



-- Ranking par revenue
SELECT 
  title, revenue,
  RANK() OVER (ORDER BY revenue DESC) as revenue_rank,
  ROW_NUMBER() OVER (ORDER BY revenue DESC) as row_num
FROM movies 
WHERE revenue > 0
LIMIT 10;


-- Top films par genre
SELECT 
  m.title, mg.genre_name, m.revenue,
  ROW_NUMBER() OVER (PARTITION BY mg.genre_name ORDER BY m.revenue DESC) as rank_in_genre
FROM movies m
JOIN movie_genres mg ON m.id = mg.movie_id
WHERE m.revenue > 0
  AND ROW_NUMBER() OVER (PARTITION BY mg.genre_name ORDER BY m.revenue DESC) <= 2;


-- Meilleurs ROI par genre
WITH profitable_movies AS (
  SELECT 
    m.title, mg.genre_name, m.budget, m.revenue,
    (m.revenue::float / m.budget) as roi
  FROM movies m
  JOIN movie_genres mg ON m.id = mg.movie_id
  WHERE m.budget > 0 AND m.revenue > 0
)
SELECT 
  genre_name, title, roi,
  RANK() OVER (PARTITION BY genre_name ORDER BY roi DESC) as roi_rank
FROM profitable_movies
WHERE RANK() OVER (PARTITION BY genre_name ORDER BY roi DESC) = 1;


-- Films au-dessus de la moyenne
SELECT title, revenue
FROM movies
WHERE revenue > (SELECT AVG(revenue) FROM movies WHERE revenue > 0)
  AND revenue > 0
ORDER BY revenue DESC;

-- Genres des films les plus rentables
SELECT DISTINCT genre_name
FROM movie_genres
WHERE movie_id IN (
  SELECT id FROM movies 
  WHERE revenue > 100000000
);
