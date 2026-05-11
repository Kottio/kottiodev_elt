-- CREATE MATERIALIZED VIEW movies_clean AS (SELECT * FROM movies 
-- WHERE budget >0 AND revenue > 0) 
-- SELECT * FROM movies_clean;
-- REFRESH MATERIALIZED VIEW movies_clean;


REFRESH MATERIALIZED VIEW movies_dashboard;

-- CREATE MATERIALIZED VIEW movies_dashboard AS (


CREATE MATERIALIZED VIEW movies_dashboard AS(SELECT 
*, 
(revenue::float / budget) as roi,
CASE 
WHEN budget > 100000000 THEN '+100M'
WHEN budget > 30000000 THEN '+30M'
ELSE '+0'
END as budget_category
FROM movies 
WHERE budget > 0 AND revenue > 0 
AND release_date > '01/01/2025'
AND (revenue::float / budget) < 30 
ORDER BY revenue desc ) 


