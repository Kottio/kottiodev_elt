from extraction import extraction_movie_data
from cleaning import clean_data
from load_data import load_all_data

def run_pipeline(): 
  print("--- Start of the Pipepline 🚀 ---")

  try:
    print("--- Extraction --- ")
    df_all_movies, df_movie_genre = extraction_movie_data()

    print("--- Cleaning --- ")
    df_movies_clean, df_genre_clean = clean_data(df_all_movies, df_movie_genre)

    print("--- Load Data ---")
    load_all_data(df_movies_clean, df_genre_clean)

  except Exception as e: 
    print("💥-- Erreur Pipeline-- ", e)


if __name__ == "__main__": 
  print("Executionde la pipeline")
  run_pipeline()
  