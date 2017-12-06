#!/bin/sh
sh /usr/local/bin/await_mysql.sh

sh /etc/sphinx/generate_sphinx_config.sh > /etc/sphinx/production.conf
/usr/bin/indexer -c /etc/sphinx/production.conf --all
/usr/bin/searchd -c /etc/sphinx/production.conf