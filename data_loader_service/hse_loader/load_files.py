import os
import requests
from bs4 import BeautifulSoup

# URL страницы
URL = "https://ba.hse.ru/bolimp"
BASE_URL = "https://ba.hse.ru"

# Создаем папку для сохранения файлов
SAVE_DIR = "benefits"
os.makedirs(SAVE_DIR, exist_ok=True)

# Загружаем страницу
response = requests.get(URL)
response.raise_for_status()

# Разбираем HTML
soup = BeautifulSoup(response.text, "html.parser")

# Ищем все строки таблицы
for row in soup.select("table.bordered tr"):
    subject_link = row.select_one("td:nth-of-type(2) a")
    pdf_link = row.select_one("td:nth-of-type(3) a.mceDataFile")

    if subject_link and pdf_link:
        subject_name = subject_link.get_text(strip=True)
        file_url = BASE_URL + pdf_link["href"]
        file_name = subject_name + ".pdf"
        file_path = os.path.join(SAVE_DIR, file_name)

        # Загружаем PDF-файл
        file_response = requests.get(file_url)
        file_response.raise_for_status()

        # Сохраняем файл
        with open(file_path, "wb") as f:
            f.write(file_response.content)

        print(f"Скачан: {file_name}")

print("Все файлы загружены в папку 'benefits'.")
