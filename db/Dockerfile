FROM postgres:latest

COPY ddl.sql /docker-entrypoint-initdb.d/
COPY insert_scripts/ /docker-entrypoint-initdb.d/