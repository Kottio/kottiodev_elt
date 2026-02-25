
def clean_data(df_all_movies,df_movie_genre ): 
    print("Nombre de films start", len(df_all_movies)) 
    df_movies_clean = df_all_movies.drop_duplicates(subset=['id'])
    df_movies_clean = df_movies_clean.dropna(subset=['id'])
    df_movies_clean = df_movies_clean.dropna(subset=['title'])
    df_movies_clean = df_movies_clean[df_movies_clean['title'].str.strip() != '']
    df_movies_clean = df_movies_clean[df_movies_clean['vote_count'] > 5 ]

    
    df_genre_clean  = df_movie_genre.dropna(subset=['movie_id', 'genre'])
    df_genre_clean = df_genre_clean[df_genre_clean['genre'].str.strip() != '']

    
    valid_ids = set(df_movies_clean['id'])
    df_genre_clean = df_genre_clean[df_genre_clean['movie_id'].isin(valid_ids)]
    
    print("Nombre de films end", len(df_movies_clean)) 
    return df_movies_clean, df_genre_clean
