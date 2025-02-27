import constants
import requests


def get_olympiads() -> dict[str: int]:
    response = requests.get(f'http://{constants.API_HOST}:{constants.API_PORT}/olympiads')
    if response.status_code != 200:
        logger.error('Cannot get olympiads')
        return dict()

    response.encoding = 'utf-8'

    olympiads = {}
    for olympiad in response.json():
        olympiads.setdefault(olympiad['name'].lower(), []).append(
            {
                'olympiad_id': olympiad['olympiad_id'],
                'profile': olympiad['profile'].lower()
            }
        )

    return olympiads