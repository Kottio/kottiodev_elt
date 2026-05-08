-- CREATE MATERIALIZED VIEW movies_clean AS (SELECT * FROM movies 
-- WHERE budget >0 AND revenue > 0) 
-- SELECT * FROM movies_clean;
-- REFRESH MATERIALIZED VIEW movies_clean;


REFRESH MATERIALIZED VIEW movies_dashboard;

-- CREATE MATERIALIZED VIEW movies_dashboard AS (


-- )
	  SELECT 
	  *, 
    (revenue::float / budget) as roi,
    CASE 
      WHEN budget > 100000000 THEN 'Blockbuster'
      WHEN budget > 30000000 THEN 'Big Budget'
      ELSE 'Small Budget'
    END as budget_category
  FROM movies 
  WHERE budget > 0 AND revenue > 0
  