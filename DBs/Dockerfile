FROM mysql:latest

ENV MYSQL_ALLOW_EMPTY_PASSWORD=true
ENV MYSQL_ROOT_PASSWORD=""

COPY ./sample_users.sql /docker-entrypoint-initdb.d/
