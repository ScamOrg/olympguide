import requests
import time
import logging
import re

from bs4 import BeautifulSoup
from hse_loader.educational_programs_loader.EducationalProgram import EducationalProgram
from clients.get_client import get_subjects, get_fields
from clients.post_client import upload_programs

logger = logging.getLogger(__name__)

def get_admission_url(program: EducationalProgram) -> str:
    program_name = program.link.split('/')[-1]
    if program_name == "fashion":
        program_name = "moda"
    if program.name == "Управление в креативных индустриях":
        program_name = "creative"
    if program_name == "digital.hse.ru":
        program_name = "digital"
    return f'https://www.hse.ru/ba/{program_name}/admission/'


# 2. Функция для получения и парсинга HTML-страницы
def fetch_program_page(url: str) -> BeautifulSoup | None:
    response = requests.get(url)
    if response.status_code == 404:
        logger.error(f"Page {url} not found (404)")
        return None
    response.encoding = 'utf-8'
    return BeautifulSoup(response.text, 'html.parser')


# 3. Функция нормализации названия предмета
def normalize_subject_name(subject_name: str) -> str:
    subject_name = subject_name.replace('/', '').strip()
    if subject_name == 'Информатика и информационно-коммуникационные технологии':
        return 'Информатика'
    return subject_name


def parse_property_subjects(property_div, exist_subjects: dict[str, int]) -> (list[int], list[int]):
    required = []
    optional = []

    title_div = property_div.find('div', class_='b-program__property-title')
    if not title_div:
        return required, optional

    title = title_div.get_text(strip=True)
    if not title.startswith('Вступительные испытания'):
        return required, optional

    subjects = property_div.find_all('li')
    for subject in subjects:
        stripped_text = list(subject.stripped_strings)
        if len(stripped_text) > 2:
            for i in range(0, len(stripped_text), 2):
                subject_name = normalize_subject_name(stripped_text[i])
                if subject_name not in exist_subjects:
                    logger.warning(f"Subject {subject_name} not found in exist subjects")
                    continue
                subject_id = exist_subjects[subject_name]
                optional.append(subject_id)
        else:
            subject_name = normalize_subject_name(stripped_text[0])
            if subject_name not in exist_subjects:
                logger.warning(f"Subject {subject_name} not found in exist subjects")
                continue
            subject_id = exist_subjects[subject_name]
            required.append(subject_id)
    return required, optional


def extract_subjects(program_properties, exist_subjects: dict[str, int]) -> (list[int], list[int]):
    required = []
    optional = []

    for property_div in program_properties:
        req, opt = parse_property_subjects(property_div, exist_subjects)
        if req or opt:
            required.extend(req)
            optional.extend(opt)
            break
    return required, optional

def parse_property_places(property_div):
    budget_places = 0
    paid_places = 0
    title_div = property_div.find('div', class_='b-program__property-title')
    if not title_div:
        return budget_places, paid_places

    title = title_div.get_text(strip=True)
    if not title.startswith('Количество мест'):
        return budget_places, paid_places

    places = property_div.find_all('p')
    for place in places:
        text = place.get_text(strip=True).replace('\xa0', ' ').split()
        if len(text) != 3:
            continue
        if not text[0].isdigit():
            continue
        if text[1].lower().startswith('б'):
            budget_places = int(text[0])
        else:
            paid_places = int(text[0])
    return budget_places, paid_places

def parse_property_fields(property_div, exist_fields: dict[str, int]) -> list[int]:
    fields = []
    title_div = property_div.find('div', class_='b-program__property-title')
    if not title_div:
        return fields

    title = title_div.get_text(strip=True)
    if not title.startswith('Обучение ведется по'):
        return fields

    fields_tag = property_div.find('p')
    for field in fields_tag.stripped_strings:
        match = re.search(r'\b\d{2}\.\d{2}\.\d{2}\b', field)
        if not match:
            logger.warning(f'Property {field} did not match')
            continue
        if match.group(0) not in exist_fields:
            logger.warning(f'Field {field} not found in exist fields')
            continue
        fields.append(exist_fields[match.group(0)])

    return fields



def extract_places(program_properties):
    budget_places = 0
    paid_places = 0
    for property_div in program_properties:
        bp, pp = parse_property_places(property_div)
        if bp or pp:
            budget_places = bp if bp is not None else 0
            paid_places = pp if pp is not None else 0
            break
    return budget_places, paid_places

def extract_fields(program_properties, exist_fields: dict[str, int]):
    fields = []
    for property_div in program_properties:
        d = parse_property_fields(property_div, exist_fields)
        if d:
            fields = d
            break
    return fields


def get_properties(soup: BeautifulSoup):
    program_properties = soup.find_all('div', class_='b-program__property')
    if not program_properties:
        logger.error("Program properties not found on page")
        return None
    return program_properties

def load_subjects_places_fields(programs: dict[str, EducationalProgram]) -> (dict[str, list[int]], dict[str, list[int]]):
    exist_subjects = get_subjects()
    exist_fields = get_fields()
    for name, program in programs.items():
        url = get_admission_url(program)
        time.sleep(3)
        soup = fetch_program_page(url)
        if not soup:
            continue

        properties = get_properties(soup)
        if not properties:
            continue

        req, opt = extract_subjects(properties, exist_subjects)
        program.required_subjects = req
        program.optional_subjects = opt
            
        if len(req) == len(opt) == 0:
            logger.error(f"Page {url} hasn't information about subjects")
            continue

        bp, pp = extract_places(properties)
        program.budget_places = bp
        program.required_places = pp
        if bp == 0 and pp == 0:
            logger.error(f"Page {url} hasn't information about places")
            continue
            
        fields = extract_fields(properties, exist_fields)
        program.fields = fields
        if not fields:
            logger.error(f"Page {url} hasn't information about fields")
            continue
        if program.cost == None:
            continue

        upload_programs(1, program)

