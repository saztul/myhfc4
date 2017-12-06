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

ADD ./scripts/* /usr/local/bin/
ADD ./scripts/generate_sphinx_config.sh /etc/sphinx/generate_sphinx_config.sh
ADD ./configs/supervisor.conf /etc/supervisord.conf
ADD ./configs/php.ini /etc/php/7.0/apache2/conf.d/myhfc.ini
ADD ./cronjobs/* /etc/cron.d/

RUN chown -R www-data:www-data /var/www \
    && chmod +x /usr/local/bin/runner.sh \
    && chmod 0644 /etc/cron.d/* \
    && touch /var/log/cron.log \
    && mkdir -p /var/sphinx/general/ /var/sphinx/logs/

