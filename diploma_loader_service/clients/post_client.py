import constants
import requests
from Diploma import Diploma

HEADERS = {
    "Authorization": f"Bearer {constants.BEARER_TOKEN}",
    "Content-Type": "application/json"
}


def post_diploma(diploma: Diploma):
    url = f'http://{constants.API_HOST}:{constants.API_PORT}/service/diploma'
    payload = {
        "user_id": diploma.user_id,
        "olympiad_id": diploma.olympiad_id,
        "class": diploma.diploma_class,
        "level": diploma.level
    }
    response = requests.post(url, json=payload, headers=HEADERS)