import camelot
import pdfplumber
import pandas as pd
from filter_df import clear
from clients.get_client import get_olympiads, get_subjects
import numpy as np
import logging
from logging_config.setup_logging import setup_logging
from Benefit import Benefit
from load_files import download_file, delete_file, get_links

setup_logging()
logger = logging.getLogger(__name__)


def add_empty_columns_if_needed(df, required_columns=11):
    """
    Добавляет пустые столбцы в начало DataFrame, если число столбцов меньше required_columns.
    """
    if df.shape[1] < required_columns:
        df.columns = range(df.shape[1])
        for k in range(required_columns - df.shape[1]):
            df.insert(0, f"Empty_Column_{k}", "")
    df.columns = range(df.shape[1])
    return df


def adjust_combined_df(df, newline_replacement=''):
    """
    Применяет общие преобразования к объединённому DataFrame:
      - отбрасывает первые два столбца,
      - удаляет вторую строку и столбцы с индексами 1 и 2,
      - сбрасывает индексы,
      - заменяет символы перевода строки.
    Параметр newline_replacement позволяет задать строку для замены.
    """
    df = df.iloc[:, 2:]
    df = df.drop(index=1)
    df = df.drop(columns=df.columns[[1, 2]])
    df = df.reset_index(drop=True)
    df = df.replace(r'\n', newline_replacement, regex=True)
    return df


def load_via_pdfplumber(pdf_path):
    """
    Загружает данные таблиц из PDF-файла с помощью pdfplumber.
    """
    logger.info(f"Начало загрузки PDF через pdfplumber: {pdf_path}")
    all_data = []

    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages, start=1):
            logger.debug(f"Обработка страницы {page_num}")
            tables = page.extract_tables()
            for table_index, table in enumerate(tables, start=1):
                df = pd.DataFrame(table)
                df = add_empty_columns_if_needed(df, required_columns=11)
                all_data.append(df)

    if not all_data:
        logger.warning(f"Таблицы не найдены в PDF: {pdf_path}")
        return np.array([])

    combined_df = pd.concat(all_data, ignore_index=True)
    # При использовании pdfplumber заменяем \n на пробел
    combined_df = adjust_combined_df(combined_df, newline_replacement=' ')
    combined_df = combined_df.replace(r'- ', '-', regex=True)
    combined_df = combined_df.replace(r' -', '-', regex=True)
    data = combined_df.to_numpy()[2:]
    return data


def process_subjects(subject_str, exist_subjects, pdf_path):
    """
    Разбивает строку с предметами, проверяет наличие каждого предмета в списке существующих,
    и возвращает строку с идентификаторами предметов, разделёнными запятыми.
    """
    subjects = subject_str.split('/')
    result = []
    for subject in subjects:
        subject_clean = subject.strip().capitalize()
        if subject_clean not in exist_subjects:
            logger.error(f"Предмет {subject_clean} не найден. PDF: {pdf_path}")
            continue
        result.append(exist_subjects[subject_clean])
    return ','.join(map(str, result))


def create_benefit_from_row(row, is_bvi, min_level, data):
    """
    Создаёт объект Benefit на основе обработанной строки.
    """
    confirmation_subjects = [{'subject_id': s, 'min_score': row[2]} for s in row[1].split(',')]
    fullscore_subjects = row[4].split(',')
    try:
        olympiad_id = int(row[0])
    except ValueError:
        logger.error(f"Некорректный идентификатор олимпиады: {row[0]}")
        olympiad_id = 0
    try:
        # Берём первые два символа для min_class, как и в обработке
        min_class = int(row[6][:2])
    except ValueError:
        logger.error(f"Некорректное значение min_class: {row[6]}")
        min_class = 0

    return Benefit(
        olympiad_id=olympiad_id,
        program_id=1,
        is_bvi=is_bvi,
        min_level=min_level,
        min_class=min_class,
        confirmation_subjects=confirmation_subjects,
        fullscore_subjects=fullscore_subjects
    )


def process_data_rows(data, exist_olympiads, exist_subjects, pdf_path):
    """
    Обрабатывает каждую строку массива данных и формирует список объектов Benefit.
    """
    benefits = []

    # Обновляем идентификаторы олимпиады, если они присутствуют в списке существующих
    for i in range(len(data)):
        if data[i, 0] != '':
            olympiad_key = data[i, 0]
            if olympiad_key not in exist_olympiads:
                logger.error(f"Олимпиада {olympiad_key} не найдена в списке существующих")
            else:
                data[i, 0] = exist_olympiads[olympiad_key]

    # Обрабатываем каждую строку для создания Benefit
    prev_row = None
    for i in range(len(data)):
        is_bvi = False
        min_level = 3
        row = list(data[i])

        for j in range(len(row)):
            if row[j] == '' and prev_row is not None:
                row[j] = prev_row[j]
                if j in [1, 4, 5]:
                    continue

            if j in [1, 4]:
                row[j] = process_subjects(row[j], exist_subjects, pdf_path)
            elif j == 2:
                row[j] = row[j][:2]
            elif j == 3:
                if 'БВИ' in row[j]:
                    is_bvi = True
            elif j == 5:
                if 'приз' not in row[j].lower():
                    min_level = 1
                row[j] = str(min_level)
            elif j == 6:
                row[j] = row[j][:2]
        prev_row = row
        benefit = create_benefit_from_row(row, is_bvi, min_level, data)
        benefits.append(benefit)

    return benefits


def process_pdf_with_camelot(pdf_path):
    """
    Загружает данные таблиц из PDF-файла с помощью Camelot.
    """
    logger.info(f"Начало загрузки PDF через Camelot: {pdf_path}")
    tables = camelot.read_pdf(pdf_path, pages="all", flavor="lattice")
    all_dataframes = []

    for table_index, table in enumerate(tables, start=1):
        logger.debug(f"Обработка таблицы {table_index} через Camelot")
        df = table.df
        df = add_empty_columns_if_needed(df, required_columns=11)
        all_dataframes.append(df)

    if not all_dataframes:
        logger.warning(f"Таблицы не найдены через Camelot в PDF: {pdf_path}")
        return pd.DataFrame()

    combined_df = pd.concat(all_dataframes, ignore_index=True)
    # При использовании Camelot заменяем \n на пустую строку
    combined_df = adjust_combined_df(combined_df, newline_replacement='')
    return combined_df


def load_benefits():
    """
    Основная функция загрузки и обработки бенефитов.
    """
    logger.info("Запуск процесса загрузки бенефитов.")
    file_list = get_links()
    exist_subjects = get_subjects()
    exist_olympiads = get_olympiads()

    count_of_benefits = 0
    for link in file_list:
        pdf_path = link.path

        logger.info(f"Обработка файла: {pdf_path}")
        download_file(link)

        combined_df = process_pdf_with_camelot(pdf_path)
        if combined_df.empty:
            logger.error(f"Не удалось извлечь данные через Camelot из PDF: {pdf_path}")
            delete_file(link)
            continue

        raw_data_list = combined_df.to_numpy().tolist()[1:]
        cleared_data = clear(raw_data_list)
        data = np.array(cleared_data, dtype=str)

        if pdf_path in ['Прикладной анализ данных.pdf', 'Компьютерные науки и анализ данных.pdf']:
            data_list = data.tolist()
            deleted_count = 0
            while data_list and data_list[0][0] == '':
                data_list.pop(0)
                deleted_count += 1
            logger.debug(f"Удалено {deleted_count} пустых строк в начале данных.")

            new_data = load_via_pdfplumber(pdf_path)
            for i in range(deleted_count):
                if i < len(new_data):
                    for j in range(len(new_data[i])):
                        new_data[i, j] = '' if new_data[i, j] is None else new_data[i, j]
                    new_data[i, 0] = new_data[i, 0].lower().strip()
                    data_list.insert(i, list(new_data[i]))
            data = np.array(data_list, dtype=str)

        benefits = process_data_rows(data, exist_olympiads, exist_subjects, pdf_path)
        logger.info(f"Из файла {pdf_path} сформировано {len(benefits)} бенефитов.")
        count_of_benefits += len(benefits)

        delete_file(link)
        logger.info(f"Удалён файл: {pdf_path}")

    logger.info(f"Завершение процесса загрузки бенефитов, было загружено {count_of_benefits} бенефитов.")


if __name__ == '__main__':
    load_benefits()