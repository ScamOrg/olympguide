import os
import requests
from dotenv import load_dotenv
import logging

logger = logging.getLogger(__name__)

load_dotenv()

API_URL = os.getenv("API_URL")
API_PORT = os.getenv("API_PORT")
def get_regions():
   pass

def get_faculties():
    pass

def get_universities():
    pass

def get_subjects() -> dict[str: int]:
    response = requests.get(f"{API_URL}:{API_PORT}/meta/subjects")
    if response.status_code != 200:
        logger.error('Cannot get regions')
        return dict()

    response.encoding = 'utf-8'

    subjects = {}

    for subject in response.json():
        subjects[subject['name']] = subject['subject_id']

    return subjects

def get_fields() -> dict[str: int]:
    response = requests.get(f"{API_URL}:{API_PORT}/fields")
    if response.status_code != 200:
        logger.error('Cannot get fields')
        return dict()

    response.encoding = 'utf-8'

    fields = {}

    for field in response.json():
        for item in field['field']:
            fields[item['code']] = item['field_id']


    return fields

def get_olympiads() -> dict[str: int]:
    response = requests.get(f"{API_URL}:{API_PORT}/olympiads")
    if response.status_code != 200:
        logger.error('Cannot get olympiads')
        return dict()

    response.encoding = 'utf-8'

    olympiads = {}

    for olympiad in response.json():
        olympiads[olympiad['name'].lower()] = olympiad['olympiad_id']

    return olympiads
