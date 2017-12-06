FROM hfcils/myhfc4:base

LABEL maintainer="Lutz Selke <ls@hfci.de>"

EXPOSE 80

VOLUME '/var/www/'
VOLUME '/etc/apache2/sites-enabled'
VOLUME '/etc/cron.d/'

# enable all german locales (iso for php) and configure timezones
RUN sed -i '/de_DE/s/^# //' /etc/locale.gen \
    && dpkg-reconfigure locales \
    && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# PHP config
ADD ./configs/php.ini /etc/php/5.6/apache2/conf.d/myhfc.ini

RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mkdir -p /opt/bin && \
    mv wkhtmltox/bin/wkhtmlto* /opt/bin/

ADD ./scripts/runner.sh /usr/bin/runner.sh
RUN chmod +x /usr/bin/runner.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/usr/bin/runner.sh" ]
