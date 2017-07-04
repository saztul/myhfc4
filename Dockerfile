FROM ubuntu:xenial

MAINTAINER Lutz Selke <ls@hfci.de>

USER root

ENV DEBIAN_FRONTEND noninteractive

# Apache 2 & PHP 7
RUN apt update && \
    apt-get -y update && \
    apt-get -y install \
        mysql-client-5.7 \
        apache2 \
        graphicsmagick \
        libapache2-mod-php7.0 \
        libgraphicsmagick-q16-3 \
        libxml2 \
        php-gettext \
        php7.0 \
        php7.0-cgi \
        php7.0-cli \
        php7.0-curl \
        php7.0-gd \
        php-imagick \
        php7.0-json \
        php7.0-mcrypt \
        php7.0-mbstring \
        php-memcache \
        php-memcached \
        php7.0-mysql \
        php7.0-mysqlnd \
        php7.0-sqlite \
        php7.0-xml \
        php7.0-xmlrpc \
        php7.0-soap \
        ssmtp \
        wkhtmltopdf \
        pdftk \
        xvfb \
        cron \
        unzip \
        language-pack-de

# enable all german locales (iso for php)
RUN sed -i '/de_DE/s/^# //' /etc/locale.gen
RUN dpkg-reconfigure locales

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

VOLUME '/var/www/'
VOLUME '/etc/apache2/sites-enabled'
VOLUME '/etc/cron.d/'

RUN apt-get -y install wget
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb
RUN dpkg -i dumb-init_*.deb

RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    apt-get -y install xz-utils && \
    tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mkdir -p /opt/bin && \
    mv wkhtmltox/bin/wkhtmlto* /opt/bin/

ADD ./scripts/runner.sh /usr/bin/runner.sh
RUN chmod +x /usr/bin/runner.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/usr/bin/runner.sh" ]
