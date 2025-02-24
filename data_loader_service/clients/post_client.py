import os
import requests
from dotenv import load_dotenv
from hse_loader.educational_programs_loader.EducationalProgram import EducationalProgram
load_dotenv()

API_URL = os.getenv("API_HOST")
API_PORT = os.getenv("API_PORT")
BEARER_TOKEN = os.getenv("BEARER_TOKEN")

HEADERS = {
    "Authorization": f"Bearer {BEARER_TOKEN}",
    "Content-Type": "application/json"
}


def create_university(name, email, site, region_id):
    url = f"{API_URL}:{API_PORT}/universities"
    payload = {
        "name": name,
        "email": email,
        "site": site,
        "region_id": region_id
    }
    response = requests.post(url, json=payload, headers=HEADERS)
    return response.json() if response.status_code == 201 else {"error": response.text}


def upload_faculties(university_id, faculties):
    url = f"{API_URL}:{API_PORT}/faculty"
    for faculty in faculties:
        payload = {
            "name": faculty,
            "university_id": university_id
        }
        response = requests.post(url, json=payload, headers=HEADERS)
        if response.status_code != 201:
            print(response.text)


def upload_programs(university_id, program: EducationalProgram):

    payload = {
        "name": program.name,
        "university_id": university_id,
        "field_id": program.fields[0],
        "faculty_id": program.faculties[0],
        "budget_places": program.budget_places,
        "paid_places": program.paid_places,
        "cost": program.cost,
        "required_subjects": program.required_subjects,
        "optional_subjects": program.optional_subjects,
        "link": program.link
    }
    response = requests.post(url, json=payload, headers=HEADERS)
    if response.status_code != 201:
        print(response.text)


def upload_benefits(university_id, privileges):
    url = f"{API_URL}:{API_PORT}/universities/{university_id}/privileges"
    response = requests.post(url, json={"privileges": privileges}, headers=HEADERS)
    return response.json() if response.status_code == 201 else {"error": response.text}