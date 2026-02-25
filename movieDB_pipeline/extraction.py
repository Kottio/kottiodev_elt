import requests
import pandas as pd 
from config import headers, get_movies_results, get_movies_details



def extraction_movie_data():

  all_movies = []
  
  print("--Start Extraction")
  for page_num in range(1,4): 
      url =f"https://api.themoviedb.org/3/movie/popular?page={page_num}" 
      response = requests.get(url,headers=headers)
      data = response.json() 
      results = data['results']

      movie_results = get_movies_results(results)
      all_movies.extend(movie_results)

  df_movies = pd.DataFrame(all_movies) 

  print("--Movie Extracted")


  movies_genres=[]
  movies_details = []

  print("--Start movie Genre extraction")
  for movie_id in df_movies.id: 
      movie_genres,movie_details_data = get_movies_details(movie_id) 
      movies_genres.extend(movie_genres) 
      movies_details.append(movie_details_data) 


  print('--Movie Genre extracted')
  df_movie_genre = pd.DataFrame(movies_genres)  
  df_movies_details = pd.DataFrame(movies_details) 
  df_all_movies = df_movies.merge(df_movies_details, left_on = "id", right_on= "movie_id") 
  df_all_movies = df_all_movies.drop("movie_id", axis=1)


  return df_all_movies, df_movie_genre

if __name__ == "__main__":
   print("extraction of the Data") 
   extraction_movie_data()
