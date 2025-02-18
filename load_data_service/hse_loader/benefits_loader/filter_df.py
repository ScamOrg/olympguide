import pandas as pd
import json
import logging
from logging_config.setup_logging import setup_logging
from clients.get_client import get_olympiads

setup_logging()
logger = logging.getLogger(__name__)


def clear(data: list):
    olympiads = get_olympiads()
    i = 0
    while i < len(data):
        data[i][0] = data[i][0].lower().strip()
        name = data[i][0]
        if name in olympiads or name == '':
            i += 1
            continue

        candidate = None

        for olympiad in olympiads:
            if olympiad.startswith(name):
                data[i][0] = olympiad
                candidate = olympiad
                break

        if candidate is None:
            j = i
            while j < len(data):
                if data[j][0] != '' and j != i:
                    break
                j += 1
            for k in range(i, j):
                del data[i]
            continue

        forget = candidate[len(name):].lower().strip().split(' ')

        j = i + 1

        while j < len(data) and forget and (data[j][0] not in olympiads):
            data[j][0] = data[j][0].lower().strip()
            while forget and forget[0] in data[j][0]:
                word = forget.pop(0)
                data[j][0] = data[j][0].replace(word, '', 1).strip()
                while '  ' in data[j][0]:
                    data[j][0] = data[j][0].replace('  ', ' ')
            j += 1

        i += 1

    return data