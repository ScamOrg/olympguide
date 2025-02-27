import os
import requests
from dotenv import load_dotenv
import logging

from hse_loader.load_files import response

logger = logging.getLogger(__name__)

load_dotenv()

API_URL = os.getenv("API_URL")
API_PORT = os.getenv("API_PORT")


def get_regions():
   pass


def get_faculties(university_id):
    response = requests.get(f"{API_URL}/university/{university_id}/faculties")
    if response.status_code != 200:
        logger.error('Cannot get regions')
        return dict()

    response.encoding = 'utf-8'

    faculties = {}

    for faculty in response.json():
        faculties[faculty['name'].lower().strip()] = faculty['faculty_id']

    return faculties


def get_programs(university_id):
    response = requests.get(f"{API_URL}/university/{university_id}/programs/by-field")
    if response.status_code != 200:
        logger.error('Cannot get regions')
        return dict()

    response.encoding = 'utf-8'

    programs = {}

    for field in response.json():
        for program in field['programs']:
            programs[program['name'.lower().strip()]] = program['program_id']

    return programs


def get_universities():
    pass


def get_subjects() -> dict[str: int]:
    response = requests.get(f"{API_URL}/meta/subjects")
    if response.status_code != 200:
        logger.error('Cannot get regions')
        return dict()

    response.encoding = 'utf-8'

    subjects = {}

    for subject in response.json():
        subjects[subject['name']] = subject['subject_id']

    return subjects


def get_fields() -> dict[str: int]:
    response = requests.get(f"{API_URL}/fields")
    if response.status_code != 200:
        logger.error('Cannot get fields')
        return dict()

    response.encoding = 'utf-8'

    fields = {}

    for field in response.json():
        for item in field['fields']:
            fields[item['code']] = item['field_id']


    return fields


def get_olympiads() -> dict[str: int]:
    response = requests.get(f"{API_URL}/olympiads")
    if response.status_code != 200:
        logger.error('Cannot get olympiads')
        return dict()

    response.encoding = 'utf-8'

    olympiads = {}
    for olympiad in response.json():
        olympiads.setdefault(olympiad['name'].lower(), {})[olympiad['profile'].lower()] = olympiad['olympiad_id']

    return olympiads


def get_profiles() -> set[str]:
    response = requests.get(f"{API_URL}/meta/olympiad-profiles")
    if response.status_code != 200:
        logger.error('Cannot get olympiad profiles')

    response.encoding = 'utf-8'

    profiles = set()
    for profile in response.json():
        profiles.add(profile)

    return profiles
