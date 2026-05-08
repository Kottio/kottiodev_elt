from extraction import extraction_movie_data
from cleaning import clean_data
from load_data import load_all_data
import sys 

def run_pipeline(): 
  print("--- Start of the Pipeline 🚀 ---")

  try:
    # print("--- Extraction --- ")
    df_all_movies, df_movie_genre = extraction_movie_data()

    # print("--- Cleaning --- ")
    df_movies_clean, df_genre_clean = clean_data(df_all_movies, df_movie_genre)

    # print("--- Load Data ---")
    load_all_data(df_movies_clean, df_genre_clean)

  except Exception as e: 
    print("💥-- Error Pipeline-- ", e)
    sys.exit(1)


if __name__ == "__main__": 
  # print("Execution de la pipeline")
  run_pipeline()
  