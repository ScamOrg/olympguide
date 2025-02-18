import pandas as pd
import json


def load_names():
    file_path = "olympiads.json"
    with open(file_path, "r", encoding="utf-8") as file:
        data = json.load(file)  # Загружаем JSON как список объектов
    # Приводим все названия к нижнему регистру
    names = [item["name"].lower() for item in data]
    return names


def filter_df(df: pd.DataFrame) -> pd.DataFrame:
    names = load_names()
    # Предполагаем, что первая строка в df – заголовок, а данные начинаются со второй строки.
    data_df = df.iloc[1:].copy()
    col_name = df.columns[0]
    # Получаем список индексов и значений первого столбца
    indices = data_df.index.tolist()
    values = data_df[col_name].astype(str).tolist()

    # Здесь будем накапливать индексы строк, которые хотим оставить, и новые (отфильтрованные) значения
    result_indices = []  # индексы строк, которые останутся
    new_values = {}  # словарь: индекс строки -> новое значение

    i = 0
    while i < len(values):
        current_val = values[i]
        norm = current_val.lower().strip()
        # Если значение равно "null", считаем его пустым
        if norm == "null":
            norm = ""
        # Если строка пустая, оставляем её (например, первая строка может быть пустой – оставляем как есть)
        if norm == "":
            result_indices.append(indices[i])
            new_values[indices[i]] = current_val  # оставляем оригинальное значение (например, "null")
            i += 1
            continue

        # Если значение уже полностью присутствует в names, считаем его корректным
        if norm in names:
            candidate = current_val  # оставляем как есть
        else:
            # Ищем первое название из списка, которое начинается с данного фрагмента
            candidate = None
            for name in names:
                if name.startswith(norm):
                    candidate = name
                    break

        if candidate is None:
            # Не найден кандидат – значит, значение невалидно.
            # Пропускаем эту строку и все следующие, пока не найдём строку,
            # которая непустая и для которой находится кандидат (то есть начало нового корректного блока)
            i += 1
            while i < len(values):
                next_val = values[i]
                next_norm = next_val.lower().strip()
                if next_norm == "null":
                    next_norm = ""
                if next_norm != "":
                    # Если строка непустая, проверяем, можно ли её считать корректной
                    if next_norm in names:
                        break
                    else:
                        for name in names:
                            if name.startswith(next_norm):
                                candidate = name
                                break
                        if candidate is not None:
                            break
                i += 1
            continue  # начинаем следующую итерацию внешнего цикла

        # Если кандидат найден – обновляем текущее значение и оставляем строку.
        result_indices.append(indices[i])
        new_values[indices[i]] = candidate
        # Вычисляем «остаток» – ту часть названия, которая не была в исходном фрагменте.
        orig = current_val.lower().strip()
        remainder = candidate[len(orig):].lower().strip() if len(candidate) > len(orig) else ""
        # Получаем список слов, которые «нужно забыть» (удалить из фрагментов)
        forget = remainder.split() if remainder else []
        i += 1

        # Далее обрабатываем последующие строки как фрагменты, относящиеся к найденному названию.
        # При этом, если встречается строка, которая либо пустая, либо сама может быть началом нового блока,
        # завершаем обработку фрагментов.
        while i < len(values):
            frag_val = values[i]
            frag_norm = frag_val.lower().strip()
            if frag_norm == "null":
                frag_norm = ""
            if frag_norm == "" or frag_norm in names or any(name.startswith(frag_norm) for name in names):
                break
            # Если фрагмент содержит часть из списка forget – удаляем эти слова
            while forget and forget[0] in frag_norm:
                word = forget.pop(0)
                frag_norm = frag_norm.replace(word, '', 1).strip()
                while '  ' in frag_norm:
                    frag_norm = frag_norm.replace('  ', ' ')
            result_indices.append(indices[i])
            new_values[indices[i]] = frag_norm
            i += 1

    # Формируем новый DataFrame из оставшихся строк
    filtered_df = data_df.loc[result_indices].copy()
    # Обновляем первый столбец по словарю new_values
    filtered_df[col_name] = filtered_df.index.map(lambda idx: new_values.get(idx, filtered_df.at[idx, col_name]))

    # Объединяем заголовок (первая строка исходного df) с отфильтрованными данными
    final_df = pd.concat([df.iloc[:1], filtered_df])
    return final_df