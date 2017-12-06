#!/bin/sh

# -p PORT     local:container
# -v VOLUME   local:container
# -e ENV VAR  A_VAR="var value"
docker rm myhfc4
docker run \
  --name myhfc4 \
  --link database-server:mysql \
  -d \
  -p 8080:80 \
  -v $(pwd)/dummy/sites:/var/www \
  -v $(pwd)/dummy/vhosts:/etc/apache2/sites-enabled \
  hfcils/myhfc4

# docker run --name some-app --link some-mysql:mysql -d application-that-uses-mysql
