import os
from dotenv import load_dotenv

load_dotenv()

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = int(os.getenv("REDIS_PORT"))
DIPLOMA_LOADER_TOPIC = "user.diplomas.upload"
REDIS_TOPICS = [DIPLOMA_LOADER_TOPIC]

API_URL = os.getenv("API_URL")
API_PORT = os.getenv("API_PORT")
BEARER_TOKEN = os.getenv("BEARER_TOKEN")