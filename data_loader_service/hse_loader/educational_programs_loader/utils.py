import requests
import re
from bs4 import BeautifulSoup

def fetch_html(url: str) -> BeautifulSoup:
    response = requests.get(url)
    response.encoding = 'utf-8'
    return BeautifulSoup(response.text, 'html.parser')

def extract_version(string: str, current_version: str) -> str:
    match = re.search(r'\b\d{2}\.\d{2}\.\d{2}\b', string)
    return match.group(0) if match else current_version

