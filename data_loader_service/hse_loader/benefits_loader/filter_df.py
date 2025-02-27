import pandas as pd
import json
import logging
from logging_config.setup_logging import setup_logging
from clients.get_client import get_olympiads, get_profiles, get_subjects

setup_logging()
logger = logging.getLogger(__name__)


def clear_name(data: list):
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


def clear_profile(data: list):
    profiles = get_profiles()

    i = 0
    while i < len(data):
        data[i][1] = data[i][1].lower().strip()
        name = data[i][1]
        if name in profiles or name == '':
            i += 1
            continue

        candidate = None

        for profile in profiles:
            if profile.startswith(name):
                data[i][1] = profile
                candidate = profile
                break

        if candidate is None:
            logger.fatal(f"Cannot find candidate to profile {name}")
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

        while j < len(data) and forget and (data[j][1] not in profiles):
            data[j][1] = data[j][1].lower().strip()
            while forget and forget[0] in data[j][1]:
                word = forget.pop(0)
                data[j][1] = data[j][1].replace(word, '', 1).strip()
                while '  ' in data[j][1]:
                    data[j][1] = data[j][1].replace('  ', ' ')
            j += 1

        i += 1

    return data


def clear_subjects(column: int, data: list):
    # subjects = get_subjects()
    i = 0
    while i < len(data):
        if data[i][column] == 'нет' or data[i][column] == '-' or data[i][column] == '':
            i += 1
            continue

        current_subjects = []
        if ',' in data[i][column]:
            current_subjects = data[i][column].lower().strip().split(',')
        else:
            current_subjects = data[i][column].lower().strip().split('/')
        for j in range(len(current_subjects)):
            current_subjects[j] = current_subjects[j].strip().lower()
            if current_subjects[j] == "истори":
                current_subjects[j] = "история"
            elif current_subjects[j] == "инфоратика":
                current_subjects[j] = "информатика"
            elif current_subjects[j] == "обществозанние":
                current_subjects[j] = "обществознание"
        if data[i][column].lower().strip().endswith('/'):
            j = i
            while j < len(data) - 1 and data[j][column].lower().strip().endswith('/'):
                new_subjects = data[j + 1][column].lower().strip().split('/')
                for new_subject in new_subjects:
                    current_subjects.append(new_subject)
                j += 1
            for k in range(i + 1, j + 1):
                data[k][column] = ""

        data[i][column] = '/'.join(s for s in current_subjects if s)
        i += 1

    return data


def clear_class(data: list):
    for i in range(len(data)):
        if data[i][7] == "":
            continue
        if "10" in data[i][7]:
            data[i][7] = "10"
        else:
            data[i][7] = "11"
    return data


def clear_level(data: list):
    for i in range(len(data)):

        if data[i][6] == "Победителям и":
            data[i][6] = "Победителям и призерам"
            data[i + 1][6] = ""
        if data[i][6] == 'ПобедителямПризерам':
            data[i][6] = "Победителям"
            data[i + 1][6] = "Призерам"
    return data

