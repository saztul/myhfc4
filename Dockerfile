FROM ubuntu:xenial

MAINTAINER Lutz Selke <ls@hfci.de>

USER root

ENV DEBIAN_FRONTEND noninteractive

# Apache 2 & PHP 7
RUN apt update \
    && apt-get -y update \
    && apt-get -y install --no-install-recommends wget ca-certificates docker.io \
    && wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
    && dpkg -i dumb-init_*.deb \
    && apt-get -y install --no-install-recommends \
        mysql-client-5.7 \
        apache2 \
        graphicsmagick \
        imagemagick \
        libapache2-mod-php \
        libxml2 \
        php-gettext \
        php \
        php-cgi \
        php-cli \
        php-curl \
        php-gd \
        php-imagick \
        php-json \
        php-mcrypt \
        php-mbstring \
        php-memcache \
        php-memcached \
        php-mysql \
        php-mysqlnd \
        php-sqlite3 \
        php-xml \
        php-xmlrpc \
        php-soap \
        php-zip \
        phpunit \
        ssmtp \
        wkhtmltopdf \
        pdftk \
        xvfb \
        cron \
        curl \
        unzip \
        language-pack-de \
        supervisor \
        xz-utils \
        libaprutil1-dbd-mysql \
        ghostscript \
        xpdf \
        poppler-utils \
        libgraphicsmagick++-q16-12 \
        libgraphicsmagick-q16-3 \
        sphinxsearch

# enable all german locales (iso for php) and configure timezones
RUN sed -i '/de_DE/s/^# //' /etc/locale.gen \
    && dpkg-reconfigure locales \
    && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata


# Apache vhost config
RUN mkdir -p /var/www/ && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2enmod rewrite && \
    a2enmod ssl && \
    a2enmod php7.0 && \
    a2dismod mpm_event && \
    a2enmod mpm_prefork

EXPOSE 80

VOLUME '/var/www'
VOLUME '/etc/apache2/sites-enabled'

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

WORKDIR /var/www

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
