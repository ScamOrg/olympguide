from bs4 import BeautifulSoup
import requests


class EducationalProgram:
    def __init__(self, name, budget_places, paid_places, link, faculties):
        self.name = name
        self.faculties = faculties
        self.budget_places = budget_places
        self.paid_places = paid_places
        self.link = link
        self.price = None

    def __repr__(self):
        return (f"EducationalProgram(name='{self.name}', budget_places={self.budget_places}, "
                f"paid_places={self.paid_places}, link='{self.link}', faculties={self.faculties})")

    def __str__(self):
        return (f"Программа: {self.name}\nФакультеты: {', '.join(self.faculties)}\n"
                f"Бюджетные места: {self.budget_places}\nПлатные места: {self.paid_places}\n"
                f"Ссылка: {self.link}\n")

def parse_educational_programs_with_faculties(url: str) -> dict:
    response = requests.get(url)
    response.encoding = 'utf-8'

    soup = BeautifulSoup(response.text, 'html.parser')
    data = {}

    edu_program_container = soup.find("div", class_="edu-programm__tab edu-programm__bachelor")

    if edu_program_container:
        programs = edu_program_container.find_all("div", class_="b-row edu-programm__item")

        for program in programs:
            # Проверяем, находится ли программа в Москве
            city_span = program.find("span", class_="edu-programm__city with-icon with-icon_flag-msk")
            if not city_span or city_span.text.strip() != "Москва":
                continue

            # Извлекаем название программы
            program_link = program.find("a", class_="link")
            program_name = program_link.text.strip()
            program_href = program_link["href"]

            # Извлекаем факультет
            faculty_span = program.find("span", class_="grey")
            if faculty_span:
                faculty_name = faculty_span.text.strip().replace("\xa0", " ")
            else:
                faculty_name = "Неизвестный факультет"

            # Извлекаем количество мест
            places_div = program.find("div", class_="edu-program-places")
            free_div = program.find("div", class_="edu-programm__place_free")
            budget_places = 0
            paid_places = 0

            if places_div:
                places = places_div.text.strip().split("/")
                if len(places) != 0:
                    budget_places = 0
                    if free_div:
                        budget_places = int(places[0]) if places[0].isdigit() else 0
                        paid_places = int(places[1]) if places[1].isdigit() else 0
                    else:
                        paid_places = int(places[0]) if places[0].isdigit() else 0

            edu_program = EducationalProgram(program_name, budget_places, paid_places, program_href, [faculty_name])

            data[program_name] = edu_program

    return data

def parse_educational_programs_price(url):
    response = requests.get(url)
    response.encoding = 'utf-8'

    soup = BeautifulSoup(response.text, 'html.parser')
    data = {}

    table = soup.find('table', class_='bordered data_small fixed_header').find_all('tbody')

    trs = []

    for tbody in table:
        current_trs = tbody.find_all('tr')

        for tr in current_trs:
            trs.append(tr)

    for tr in trs:
        tds = tr.find_all('td')
        link = tds[0].find('a')
        if len(tds) == 2 and link:
            name = tds[0].get_text().replace('\xa0', ' ').replace('  ', ' ').split('/')[0]
            if name == "Совместный бакалавриат НИУ ВШЭ и Центра педагогического мастерства":
                name = "Совместный бакалавриат НИУ ВШЭ и ЦПМ"
                "Экономика и статистика"
            price = int(tds[1].get_text().strip()) * 1000
            data[name] = price

    return data

def parse_educational_programs_prices(url):
    response = requests.get(url)
    response.encoding = 'utf-8'

    soup = BeautifulSoup(response.text, 'html.parser')
    data = {}

    table = soup.find('table').find('tbody')

    trs = table.find_all('tr')

    for tr in trs:
        tds = tr.find_all('td')
        link = tds[0].find('a')
        if link:
            name = tds[0].get_text().replace('\xa0', ' ').replace('  ', ' ').split('/')[0].strip()
            if name == "Турция и тюрский мир":
                name = "Турция и тюркский мир"
            price = int(tds[-1].get_text().strip())
            data[name] = price

    return data

if __name__ == '__main__':
    url = 'https://www.hse.ru/education/msk/bachelor/'
    educational_programs = parse_educational_programs_with_faculties(url)
    url = 'https://ba.hse.ru/price'
    programs_price = parse_educational_programs_price(url)
    url = 'https://admissions.hse.ru/undergraduate-apply/fees'
    program_prices = parse_educational_programs_prices(url)

    for program, price in programs_price.items():
        if program not in educational_programs:
            print(program, price)
        else:
            educational_programs[program].price = price

    print()
    for program, price in program_prices.items():
        if program not in educational_programs:
            print(program, price)
        else:
            educational_programs[program].price = price

    print()
    for program, value in educational_programs.items():
        if value.price == None:
            print(value.name)


