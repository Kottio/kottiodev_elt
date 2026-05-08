import requests
from config import headers

url="https://api.themoviedb.org/3/authentication"
response=requests.get(url, headers=headers)

if response.status_code == 200: 
  print("API Access Working")
else:
  raise Exception(f"API Access not Working : {response.status_code} - {response.text}")

