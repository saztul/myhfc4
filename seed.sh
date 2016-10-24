#!/bin/sh
docker exec database-server sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS foo;"'
docker exec -i database-server mysql -uroot -ptest-pw --default-character-set=utf8 --database foo < dummy/seed.sql