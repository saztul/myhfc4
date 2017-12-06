#!/bin/sh
docker run \
  --name database-server \
  -v $(pwd)/dummy/mysql-data:/var/lib/mysql \
  -v $(pwd)/dummy/mysql-config:/etc/mysql/conf.d \
  -e MYSQL_ROOT_PASSWORD="test-pw" \
  -d \
  mysql:5.7


