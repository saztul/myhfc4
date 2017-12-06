#!/usr/bin/dumb-init /bin/sh

# allow changing of apache user
if [ -n "$APACHE_UID" ]; then
  usermod --non-unique --uid $APACHE_UID www-data
fi

# add dns entries for all apache vhosts
echo "127.0.0.1 client.container myhfc.container scripts.container" >> /etc/hosts

# remove apache pid from previous run
rm -f /var/run/apache2/apache2.pid

# start apache
/usr/sbin/apachectl -d /etc/apache2 -e info -D FOREGROUND
