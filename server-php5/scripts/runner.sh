#!/usr/bin/dumb-init /bin/sh
if [ -n "$APACHE_UID" ]; then
  usermod --non-unique --uid $APACHE_UID www-data
fi

rm -f /var/run/apache2/apache2.pid

/usr/sbin/cron &
/usr/sbin/apachectl -d /etc/apache2 -e info -D FOREGROUND
