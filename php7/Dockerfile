FROM hfcils/myhfc4:base7

LABEL maintainer="Lutz Selke <ls@hfci.de>"

EXPOSE 80

VOLUME '/var/www'
VOLUME '/etc/apache2/sites-enabled'

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

# enable all german locales (iso for php) and configure timezones
RUN sed -i '/de_DE/s/^# //' /etc/locale.gen \
    && dpkg-reconfigure locales \
    && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mkdir -p /opt/bin && \
    mv wkhtmltox/bin/wkhtmlto* /opt/bin/

ADD ./scripts/runner.sh /usr/local/bin/runner.sh
ADD ./scripts/sphinx_server.sh /usr/local/bin/sphinx_server.sh
ADD ./scripts/sphinx_indexer.sh /usr/local/bin/sphinx_indexer.sh
ADD ./scripts/wkhtmltopdf /usr/local/bin/wkhtmltopdf
ADD ./scripts/wkhtmltoimage /usr/local/bin/wkhtmltoimage
ADD ./scripts/generate_sphinx_config.sh /etc/sphinx/generate_sphinx_config.sh
ADD ./scripts/await_mysql.sh /usr/local/bin/await_mysql.sh
ADD ./configs/supervisor.conf /etc/supervisord.conf
ADD ./configs/php-dev.ini /etc/php/7.0/apache2/conf.d/30-php-dev.ini
ADD ./cronjobs/cron \
    ./cronjobs/sphinx-index-all \
    ./cronjobs/sphinx-index-general \
    /etc/cron.d/

RUN chown -R www-data:www-data /var/www \
    && chmod +x /usr/local/bin/runner.sh \
    && chmod 0644 /etc/cron.d/* \
    && touch /var/log/cron.log \
    && mkdir -p /var/sphinx/general/ /var/sphinx/logs/

