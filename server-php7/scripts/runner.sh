#!/usr/bin/dumb-init /bin/sh
if [ -n "$APACHE_UID" ]; then
  usermod --non-unique --uid $APACHE_UID www-data
fi

# create .sessions directory
mkdir -p /var/www/.sessions
chown www-data:www-data -R /var/www/.sessions

rm -f /var/run/apache2/apache2.pid
/usr/sbin/apachectl -d /etc/apache2 -e info -D FOREGROUND
