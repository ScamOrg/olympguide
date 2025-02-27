from bs4 import BeautifulSoup
from hse_loader.educational_programs_loader.EducationalProgram import EducationalProgram
from hse_loader.educational_programs_loader.utils import fetch_html
from clients.get_client import get_faculties
import logging

logger = logging.getLogger(__name__)

def get_edu_program_container(soup: BeautifulSoup):
    return soup.find("div", class_="edu-programm__tab edu-programm__bachelor")

def is_moscow_program(program_div) -> bool:
    city_span = program_div.find("span", class_="edu-programm__city with-icon with-icon_flag-msk")
    return city_span and city_span.text.strip() == "Москва"

def extract_program_link_and_name(program_div) -> tuple[str, str]:
    program_link = program_div.find("a", class_="link")
    program_name = program_link.text.strip()
    program_href = program_link["href"]

    if program_name == "Современное искусство":
        program_href = 'https://design.hse.ru/ba/program/art'
    return program_name, program_href

def extract_faculty(program_div, exist_faculties) -> str:
    faculty_span = program_div.find("span", class_="grey")
    result = []
    if faculty_span:
        faculties =  faculty_span.text.strip().replace("\xa0", " ").split(',')
        for faculty in faculties:
            faculty_strip = faculty.strip().lower()
            if faculty_strip in exist_faculties:
                result.append(exist_faculties[faculty_strip])
            else:
                logger.error(f"Факультета {faculty_strip} нет")
        return result
    return [0]

def extract_places(program_div) -> tuple[int, int]:
    places_div = program_div.find("div", class_="edu-program-places")
    free_div = program_div.find("div", class_="edu-programm__place_free")
    budget_places = 0
    paid_places = 0
    if places_div:
        places = places_div.text.strip().split("/")
        if places:
            if free_div:
                budget_places = int(places[0]) if places[0].isdigit() else 0
                paid_places = int(places[1]) if len(places) > 1 and places[1].isdigit() else 0
            else:
                paid_places = int(places[0]) if places[0].isdigit() else 0
    return budget_places, paid_places

def parse_educational_programs_with_faculties() -> dict[str: EducationalProgram]:
    url = 'https://www.hse.ru/education/msk/bachelor/'
    soup = fetch_html(url)
    data = {}
    container = get_edu_program_container(soup)
    exist_faculties = get_faculties(1)
    if container:
        programs = container.find_all("div", class_="b-row edu-programm__item")
        for program_div in programs:
            if not is_moscow_program(program_div):
                continue
            program_name, program_href = extract_program_link_and_name(program_div)
            faculty_name = extract_faculty(program_div, exist_faculties)
            budget_places, paid_places = extract_places(program_div)
            edu_program = EducationalProgram(program_name, budget_places, paid_places, program_href, faculty_name)
            data[program_name] = edu_program
    return data