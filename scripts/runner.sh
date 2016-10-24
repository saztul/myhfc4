#!/usr/bin/dumb-init /bin/sh
/usr/sbin/cron &
/usr/sbin/apachectl -d /etc/apache2 -e info -D FOREGROUND