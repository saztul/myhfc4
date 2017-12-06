#!/bin/sh
sh /usr/local/bin/await_mysql.sh

while true; do
    echo '[Sphinx indexer] Waiting 30s..'
    sleep 300
    /usr/bin/indexer \
      -c /etc/sphinx/production.conf \
      --all \
      --rotate
    if [ "$?" = "0" ]; then
      exit 1
    fi
done