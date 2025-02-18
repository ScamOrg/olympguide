import os
import requests
from bs4 import BeautifulSoup
import logging
from logging_config.setup_logging import setup_logging

setup_logging()

logger = logging.getLogger(__name__)

class LinkWithName:
    def __init__(self, link, path):
        self.link = link
        self.path = path

URL = "https://ba.hse.ru/bolimp"
BASE_URL = "https://ba.hse.ru"


def get_links():
    links = []
    response = requests.get(URL)
    response.raise_for_status()

    # Разбираем HTML
    soup = BeautifulSoup(response.text, "html.parser")

    # Ищем все строки таблицы
    for row in soup.select("table.bordered tr"):
        subject_link = row.select_one("td:nth-of-type(2) a")
        pdf_link = row.select_one("td:nth-of-type(3) a.mceDataFile")

        if subject_link and pdf_link:
            subject_path = subject_link.get_text(strip=True) + ".pdf"
            file_url = BASE_URL + pdf_link["href"]
            links.append(LinkWithName(link=file_url, path=subject_path))

    return links


def download_file(subject: LinkWithName):
    # Загружаем PDF-файл
    file_response = requests.get(subject.link)
    file_response.raise_for_status()

    # Сохраняем файл
    with open(subject.path, "wb") as f:
        f.write(file_response.content)

    logger.info(f"{subject.path} was downloaded")

def delete_file(subject):
    if os.path.exists(subject.path):
        os.remove(subject.path)
        logger.info(f"File {subject.path} has been deleted")
