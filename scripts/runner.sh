#!/usr/bin/dumb-init /bin/sh
if [ -n "$APACHE_UID" ]; then
  usermod --non-unique --uid $APACHE_UID www-data
fi
/usr/sbin/cron &
/usr/sbin/apachectl -d /etc/apache2 -e info -D FOREGROUND
