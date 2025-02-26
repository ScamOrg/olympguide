from bs4 import BeautifulSoup
import requests
from clients.post_client import upload_faculties


def load_faculties(university_id) -> list:
    url = "https://www.hse.ru/education/faculty/"
    response = requests.get(url)
    response.encoding = 'utf-8'

    soup = BeautifulSoup(response.text, 'html.parser')

    posts_container = soup.find("div", class_="posts cards")
    faculties = []

    if posts_container:
        post_items = posts_container.find_all("div", class_="post__item grey")

        for post in post_items:
            faculties.append(post.text.strip().replace('\u00AD', ''))

    result = []
    for faculty in faculties:
        for f in faculty.split('\n'):
            result.append(f.replace('\xa0', ' ').replace('\u00AD', ' '))

    upload_faculties(university_id, result)

if __name__ == '__main__':
    load_faculties(1)