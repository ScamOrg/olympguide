import os
from dotenv import load_dotenv

load_dotenv()

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = int(os.getenv("REDIS_PORT"))
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD")

DIPLOMA_LOADER_TOPIC = "user.diplomas.upload"
REDIS_TOPICS = [DIPLOMA_LOADER_TOPIC]

API_HOST = os.getenv("API_HOST")
API_PORT = os.getenv("API_PORT")
BEARER_TOKEN = os.getenv("BEARER_TOKEN")