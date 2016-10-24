#!/bin/sh
docker run -d \
  --name phpmyadmin \
  --link database-server:db \
  -p 8888:80 \
  -e PMA_ABSOLUTE_URI="http://localhost:8888/" \
  phpmyadmin/phpmyadmin
