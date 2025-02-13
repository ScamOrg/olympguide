import camelot
import pandas as pd
import os
from filter_df import filter_df
import time

SAVE_DIR = "benefits"

file_list = os.listdir(SAVE_DIR)

for path in file_list:
    if path != "Философия.pdf":
        continue
    print(path)
    pdf_path = "benefits/" + path

    # Считываем все страницы PDF
    tables = camelot.read_pdf(pdf_path, pages="all", flavor="lattice")

    # Собираем все данные в один DataFrame
    all_data = []

    for i, table in enumerate(tables):
        df = table.df
        if df.shape[1] < 11:
            df.columns = range(df.shape[1])
            for k in range(11 - df.shape[1]):
                df.insert(0, f"Empty_Column_{k}", "")

        df.columns = range(df.shape[1])
        all_data.append(df)

    # Объединяем все DataFrame в один
    combined_df = pd.concat(all_data, ignore_index=True)
    combined_df = combined_df.iloc[:, 2:]
    # combined_df = combined_df.iloc[2:, :]
    # Удаляем вторую строку
    combined_df = combined_df.drop(index=1)

    # Удаляем 2-й, 3-й, 4-й и 9-й столбцы (нумерация с 0)
    combined_df = combined_df.drop(columns=combined_df.columns[[1, 2, 3, 4]])

    # Сбрасываем индексы (по желанию)
    combined_df = combined_df.reset_index(drop=True)
    combined_df = combined_df.replace(r'\n', '', regex=True)
    # Сохраняем в единый CSV

    combined_df = filter_df(combined_df)

    time.sleep(4)

    combined_df.to_csv("all_tables.csv", index=False, encoding="utf-8-sig")
