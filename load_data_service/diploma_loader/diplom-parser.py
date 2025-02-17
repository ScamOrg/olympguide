import re
import hashlib
import requests
import demjson3


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

def get_diplomas(last_name, first_name, middle_name, day, month, year, base_year="2024"):

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
            diplomas.append(item["oa"])
    return diplomas


if __name__ == "__main__":
    last_name = input("Last name: ")
    first_name = input("First name: ")
    middle_name = input("Middle name: ")
    day = input("Day: ")
    month = input("Month: ")
    year = input("Year: ")

    found = get_diplomas(last_name, first_name, middle_name, day, month, year, base_year="2022")

    if found:
        for d in found:
            print(d)
    else:
        print("Дипломов не найдено.")