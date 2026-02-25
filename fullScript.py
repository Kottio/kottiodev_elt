from dotenv import load_dotenv
import os
import pandas as pd
import requests
from sqlalchemy import create_engine, text 

load_dotenv()

host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
dbname = os.getenv("DB_NAME")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")

DATABASE_URL= f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

MOVIEDB_TOKEN = os.getenv("MOVIE_DB_TOKEN")


def get_movies_results(results):
    movies=[]
    
    for movie in results: 
        movie_data ={
            "id": movie['id'],
            "title": movie["title"],
            "original_language": movie["original_language"],
            "release_date": movie["release_date"],
            "popularity": movie["popularity"], 
            "vote_average": movie["vote_average"], 
            "vote_count": movie["vote_count"]
        }
        
        movies.append(movie_data)
    
    return movies
      

def get_movies_details(movie_id): 
    url = f"https://api.themoviedb.org/3/movie/{movie_id}"
    response = requests.get(url,headers=headers)
    data = response.json() 
    movie_genres =[] 

    # Extraction genre du film
    for genre in data['genres']: 
        genre_data={
            'movie_id': movie_id,
            'genre': genre['name']
        }
        movie_genres.append(genre_data)
    
    movie_details ={
        'movie_id': movie_id, 
        'budget': data['budget'], 
        'revenue': data['revenue'], 
        'runtime': data['runtime']
    }

    return  movie_genres, movie_details

headers= {
    "accept": "application/json",
    "Authorization": f"Bearer {MOVIEDB_TOKEN}"
}

all_movies = []


for page_num in range(1,4): 
    url =f"https://api.themoviedb.org/3/movie/popular?page={page_num}" 
    response = requests.get(url,headers=headers)
    data = response.json() 
    results = data['results']

    movie_results = get_movies_results(results)
    all_movies.extend(movie_results)

df_movies = pd.DataFrame(all_movies) 


movies_genres=[]
movies_details = []

for movie_id in df_movies.id: 
    movie_genres,movie_details_data = get_movies_details(movie_id) 
    movies_genres.extend(movie_genres) 
    movies_details.append(movie_details_data) 


df_movie_genre = pd.DataFrame(movies_genres)  
df_movies_details = pd.DataFrame(movies_details) 
df_all_movies = df_movies.merge(df_movies_details, left_on = "id", right_on= "movie_id") 
df_all_movies = df_all_movies.drop("movie_id", axis=1) 


engine = create_engine(DATABASE_URL) 
with engine.connect() as conn: 
    with conn.begin(): 
        conn.execute(text("DELETE FROM movies_genres;"))
        conn.execute(text("DELETE FROM movies;"))
        
df_all_movies.to_sql('movies',engine, if_exists='append', index=False )
df_movie_genre.to_sql('movies_genres',engine, if_exists='append', index=False )

top_movies = pd.read_sql("SELECT * FROM movies ORDER BY popularity DESC LIMIT 10;", engine)