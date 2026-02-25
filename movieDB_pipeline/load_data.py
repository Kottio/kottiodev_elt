from sqlalchemy import create_engine, text 
import pandas as pd
from config import DATABASE_URL

def load_all_data(df_movies_clean,df_movies_genre_clean ):
  engine = create_engine(DATABASE_URL) 
  with engine.connect() as conn: 
      print("Deleting data")
      with conn.begin(): 
          conn.execute(text("DELETE FROM movies_genres;"))
          conn.execute(text("DELETE FROM movies;"))


  print("Writing New Tables")        
  df_movies_clean.to_sql('movies',engine, if_exists='append', index=False )
  df_movies_genre_clean.to_sql('movies_genres',engine, if_exists='append', index=False )

  print("Writing Success")
  top_movies = pd.read_sql("SELECT * FROM movies ORDER BY popularity DESC LIMIT 1;", engine)
  print("Accessing first row", top_movies )
