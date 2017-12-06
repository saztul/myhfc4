FROM hfcils/myhfc4:base-php5

LABEL author="Lutz Selke <ls@hfci.de>"

WORKDIR /var/www/
VOLUME "/etc/ssmtp"
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

RUN sed -i '/de_DE/s/^# //' /etc/locale.gen \
    && dpkg-reconfigure locales \
    && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && mkdir -p /var/www/files \
    && mkdir -p /var/www/logs/system \
    && touch /var/log/cron.log

ADD ./php/* /etc/php/5.6/apache2/conf.d/
ADD ./vhosts/* /etc/apache2/sites-enabled/
ADD ./supervisor.conf /etc/supervisord.conf
ADD ./runner.sh /usr/local/bin/runner.sh

RUN chmod +x /usr/local/bin/runner.sh \
    && chmod 0644 /etc/cron.d/* \
    && a2enmod vhost_alias

