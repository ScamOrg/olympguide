from typing import Tuple, Any

from bs4 import BeautifulSoup
from hse_loader.educational_programs_loader.utils import fetch_html
from hse_loader.educational_programs_loader.EducationalProgram import EducationalProgram

def extract_rows_second_source(soup: BeautifulSoup) -> list:
    table = soup.find('table')
    if not table:
        return []
    tbody = table.find('tbody')
    return tbody.find_all('tr') if tbody else []

def process_row_second_source(tr, special_name_changes: dict) -> tuple[Any, int] | None:
    tds = tr.find_all('td')
    link = tds[0].find('a') if tds else None
    if link:
        raw_name = tds[0].get_text().replace('\xa0', ' ').replace('  ', ' ').split('/')[0].strip()
        name = special_name_changes.get(raw_name, raw_name)
        price_text = tds[-1].get_text().strip()
        price = int(price_text) * 1000 if price_text.isdigit() else 0
        return name, price
    return None

def load_costs_from_second_source(programs: dict[str, EducationalProgram]):
    url = 'https://admissions.hse.ru/undergraduate-apply/fees'
    soup = fetch_html(url)
    rows = extract_rows_second_source(soup)
    special_name_changes = {
        "Турция и тюрский мир": "Турция и тюркский мир"
    }
    for tr in rows:
        result = process_row_second_source(tr, special_name_changes)
        if result:
            name, cost = result
            if name in programs:
                if programs[name].cost == None or programs[name].cost == 0:
                    programs[name].cost = cost


def extract_rows_first_source(soup: BeautifulSoup) -> list:
    table = soup.find('table', class_='bordered data_small fixed_header')
    if not table:
        return []
    tbodies = table.find_all('tbody')
    rows = []
    for tbody in tbodies:
        rows.extend(tbody.find_all('tr'))
    return rows

def process_row_first_source(tr, special_name_changes: dict) -> tuple[Any, int] | None:
    tds = tr.find_all('td')
    link = tds[0].find('a') if tds else None
    if len(tds) == 2 and link:
        raw_name = tds[0].get_text().replace('\xa0', ' ').replace('  ', ' ').split('/')[0]
        name = special_name_changes.get(raw_name, raw_name)
        price_text = tds[1].get_text().strip()
        price = int(price_text) * 1000 if price_text.isdigit() else 0
        return name, price
    return None
def load_costs_from_first_source(programs: dict[str, EducationalProgram]):
    url = 'https://ba.hse.ru/price'
    soup = fetch_html(url)
    rows = extract_rows_first_source(soup)
    special_name_changes = {
        "Совместный бакалавриат НИУ ВШЭ и Центра педагогического мастерства": "Совместный бакалавриат НИУ ВШЭ и ЦПМ"
    }
    for tr in rows:
        result = process_row_first_source(tr, special_name_changes)
        if result:
            name, cost = result
            if name in programs:
                programs[name].cost = cost