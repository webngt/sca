## Запуск Postgres в Docker

Выполните в терминале команду для запуска Postgres в Docker-контейнере:

`docker run --name postgres -e POSTGRES_PASSWORD=postgres -d postgres`{{execute}}

Для запуска не требуется дополнительная конфигурация образа контейнера.
