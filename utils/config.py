from dotenv import load_dotenv
import os 
load_dotenv()

print(f'This the host of our Database: {os.getenv("DB_HOST")}')
print(f'This the Name of our Database: {os.getenv("DB_NAME")}')