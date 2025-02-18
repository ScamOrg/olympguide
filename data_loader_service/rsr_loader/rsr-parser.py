import json
import requests
from bs4 import BeautifulSoup

# URL страницы
url = 'https://rsr-olymp.ru/'
# Отправляем GET-запрос к странице
response = requests.get(url)
response.encoding = 'utf-8'

# Парсим HTML с помощью BeautifulSoup
soup = BeautifulSoup(response.text, 'html.parser')

# Находим таблицу
table = soup.find('table', class_='mainTableInfo')

# Извлекаем данные
olympiads = []
current_olympiad = None
current_number = 0
current_name = ''
current_link = ''
for row in table.find('tbody').find_all('tr'):
    cols = row.find_all('td')

    if len(cols) == 5:
        current_olympiad = {
            'name': cols[1].text.strip(),
            'profile': cols[2].text.strip(),
            'level': int(cols[4].text.strip()),
            'link': cols[1].a['href']
        }
        current_number = int(cols[0].text.strip())
        current_name = cols[1].text.strip()
        current_link = cols[1].a['href']
    else:
        current_olympiad = {
            'name': current_name,
            'profile': cols[0].text.strip(),
            'level': int(cols[2].text.strip()),
            'link': current_link
        }
    olympiads.append(current_olympiad)

# Сохраняем данные в JSON
json_filename = 'olympiads.json'
with open(json_filename, 'w', encoding='utf-8') as jsonfile:
    json.dump(olympiads, jsonfile, ensure_ascii=False, indent=4)

print(f"Данные успешно сохранены в файл {json_filename}")