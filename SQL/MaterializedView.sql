CREATE MATERIALIZED VIEW movies_clean AS (SELECT * FROM movies 
WHERE budget >0 AND revenue > 0) 


SELECT * FROM movies_clean;

REFRESH MATERIALIZED VIEW movies_clean;