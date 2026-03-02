CREATE TABLE IF NOT EXISTS movies(
	id INTEGER PRIMARY KEY,
	title VARCHAR(255),
	original_language VARCHAR(10),
	release_date DATE,
	popularity DECIMAL(8,4),
	vote_average DECIMAL(5,3),
	vote_count INTEGER,
	budget BIGINT,
	revenue BIGINT,
	runtime INTEGER
)

CREATE TABLE IF NOT EXISTS movies_genres(
	movie_id INTEGER,
	genre VARCHAR(100),
	FOREIGN KEY (movie_id)REFERENCES movies(id)
)


SELECT * FROM movies_genres;