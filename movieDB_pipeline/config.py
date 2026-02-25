from dotenv import load_dotenv
import os
import requests

load_dotenv()

# Own Database Details
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
dbname = os.getenv("DB_NAME")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")

DATABASE_URL= f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

MOVIEDB_TOKEN = os.getenv("MOVIE_DB_TOKEN")

headers= {
    "accept": "application/json",
    "Authorization": f"Bearer {MOVIEDB_TOKEN}"
}

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