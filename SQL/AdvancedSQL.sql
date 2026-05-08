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



-- Genres des films les plus rentables
SELECT DISTINCT genre_name
FROM movie_genres
WHERE movie_id IN (
  SELECT id FROM movies 
  WHERE revenue > 100000000
);