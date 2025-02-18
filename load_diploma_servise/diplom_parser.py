import constants
import redis
import logging
import re
import hashlib
import requests
import demjson3
from logging_config.setup_logging import setup_logging
import clients.get_client
import clients.post_client
from Diploma import Diploma

setup_logging()
logger = logging.getLogger(__name__)

redis_client = redis.StrictRedis(host=constants.REDIS_HOST,
                                 port=constants.REDIS_PORT,
                                 decode_responses=True)


def make_namestring(last_name, first_name, middle_name, year, month, day):
    name = f"{last_name} {first_name} {middle_name}"

    name = name.lower()

    pattern = re.compile(r'((?:^|[- ])[^\s])')
    def upper_first(match):
        return match.group(1).upper()
    name = pattern.sub(upper_first, name)

    d = f"{int(day):02d}"
    m = f"{int(month):02d}"
    name += f" {year}-{m}-{d}"

    name = re.sub(r'\s+', ' ', name).strip()

    return name


def get_sha256(text):
    return hashlib.sha256(text.encode('utf-8')).hexdigest()


def parse_diploma_codes_js(js_text):

    pattern = r'diplomaCodes\s*=\s*(\[[\s\S]*?\]);'
    match = re.search(pattern, js_text)
    if not match:
        return []
    array_str = match.group(1)
    try:
        data = demjson3.decode(array_str)
    except demjson3.JSONDecodeError as e:
        raise ValueError(f"Ошибка парсинга ответа: {e}")
    return data


def get_diplomas(last_name, first_name, middle_name, day, month, year, base_year):

    namestring = make_namestring(last_name, first_name, middle_name, year, month, day)

    hash_val = get_sha256(namestring)

    url = (
        "https://diploma.rsr-olymp.ru/files/rsosh-diplomas-static/"
        f"compiled-storage-{base_year}/by-person-released/{hash_val}/codes.js"
    )

    resp = requests.get(url)
    if resp.status_code == 404:
        return []
    elif resp.status_code != 200:
        raise RuntimeError(f"код ответа: {resp.status_code}")
    data = parse_diploma_codes_js(resp.text)

    if not isinstance(data, list):
        return []

    diplomas = []
    for item in data:
        if isinstance(item, dict) and "oa" in item:
            if isinstance(item, dict) and "form" in item:
                diplomas.append([item["oa"], item["form"]])
    return diplomas


def process_diplomas(diplomas: list[str], user_id: int):
    olympiads = clients.get_client.get_olympiads()
    for diploma in diplomas:
        diploma_text = diploma[0].lower()
        olympiad_data = None
        for olympiad_name in olympiads:
            if olympiad_name in diploma_text:
                olympiad_data = olympiads[olympiad_name]
                break

        if olympiad_data:
            profile = diploma_text.split('(\"')[1].split('\")')[0]
            olympiad_id = None
            for olympiad in olympiad_data:
                if profile == olympiad['profile']:
                    olympiad_id = olympiad['olympiad_id']

            level = int(diploma_text.split('.')[-2].split(' ')[-2])

            clients.post_client.post_diploma(
                Diploma(
                    user_id=user_id,
                    olympiad_id=olympiad_id,
                    level=level,
                    diploma_class=diploma[1]
                )
            )

        else:
            logger.warning(f'Not found olympiad {diploma}')



def process_diploma_loader(topic, message):
    data = eval(message)
    if topic == constants.EMAIL_CODE_TOPIC:
        birthday = data["birthday"].split('.')
        diplomas = []
        current_date = int(datetime.datetime.now().strftime('%Y'))
        for i in range(3):
            new_diplomas = get_diplomas(
                data['last_name'],
                data['first_name'],
                data['second_name'],
                birthday[0],
                birthday[1],
                birthday[2],
                str(current_date - i)
            )
            for diploma in new_diplomas:
                diplomas.append(diploma)

        if diplomas:
            process_diplomas(diplomas, data['user_id'])


def process_redis_diploma_loader():
    logger.info("Listening for messages...")
    pubsub = redis_client.pubsub()
    pubsub.subscribe(constants.REDIS_TOPICS)

    for message in pubsub.listen():
        if message['type'] == 'message':
            topic = message['channel']
            message_data = message['data']
            logger.info(f"Received message from {topic}: {message_data}")
            process_diploma_loader(topic, message_data)


if __name__ == "__main__":
    process_redis_diploma_loader()
