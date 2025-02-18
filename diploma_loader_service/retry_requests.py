import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

def fetch_with_retries(url):
    session = requests.Session()
    retries = Retry(
        total=5,
        backoff_factor=1,  # Задержка перед повтором: 1, 2, 4, 8 секунд
        status_forcelist=[500, 502, 503, 504],
        allowed_methods=["GET"],
    )
    session.mount("https://", HTTPAdapter(max_retries=retries))

    try:
        resp = session.get(url, allow_redirects=True, timeout=10)
        return resp
    except requests.exceptions.RequestException as e:
        raise RuntimeError(f"Ошибка сети: {e}")