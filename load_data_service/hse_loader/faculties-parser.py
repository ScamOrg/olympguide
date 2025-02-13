from bs4 import BeautifulSoup
import requests


def parse_faculty(url: str) -> list:
    response = requests.get(url)
    response.encoding = 'utf-8'

    soup = BeautifulSoup(response.text, 'html.parser')

    posts_container = soup.find("div", class_="posts cards")
    faculties = []

    if posts_container:
        post_items = posts_container.find_all("div", class_="post__item grey")

        for post in post_items:
            faculties.append(post.text.strip().replace('\u00AD', ''))

    return faculties


if __name__ == '__main__':
    url = "https://www.hse.ru/education/faculty/"
    parse_faculty(url)
