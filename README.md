***Правила разработки***
1. Для любых изменений создаётся отдельная ветка, которая потом через `pull-request` и `review` и `merge`'ится с `main`.
   Название коммита слияния при этом начинается с названия задачи в трекере.
   Пример: "PLAN-10: добавлена ручка для донатов"
2. После clone репозитория стоит создать `.env` файл с переменными, которые используются в `docker-compose.yaml` и переменной DB_HOST=localhost, чтобы при локальном запуске бэк знал, где находится бд.
3. Для запуска всех сервисов достаточно использовать команду `docker compose up -d`, так и должно остаться после вливания изменений.
4. Для работы над бэком запускается база данных `docker compose up -d db` а бэк запускается и отлаживается локально.
