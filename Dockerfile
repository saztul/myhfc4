FROM ubuntu:xenial

MAINTAINER Lutz Selke <ls@hfci.de>

USER root

ENV DEBIAN_FRONTEND noninteractive

# Adding extra repos like php-5.6
ADD ./apt/sources/* /etc/apt/sources.list.d/
ADD ./apt/keys/* /etc/apt/trusted.gpg.d/

# Apache 2 & PHP 5.6
RUN apt update && \
    apt-get -y update && \
    apt-get -y install \
        mysql-client-5.7 \
        apache2 \
        graphicsmagick \
        libapache2-mod-php5.6 \
        libgraphicsmagick3 \
        libxml2 \
        php-gettext \
        php5.6 \
        php5.6-cgi \
        php5.6-cli \
        php5.6-curl \
        php5.6-gd \
        php5.6-imagick \
        php5.6-json \
        php5.6-mcrypt \
        php5.6-mbstring \
        php5.6-memcache \
        php5.6-memcached \
        php5.6-mysql \
        php5.6-mysqlnd \
        php5.6-sqlite \
        php5.6-xml \
        php5.6-zip \
        php5.6-xmlrpc \
        php5.6-soap \
        phpunit \
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

# PHP config
ADD ./php/* /etc/php/5.6/apache2/

# Apache vhost config
RUN mkdir -p /var/www/ && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2enmod rewrite && \
    a2enmod ssl && \
    a2enmod php5.6 && \
    a2dismod mpm_event && \
    a2enmod mpm_prefork

EXPOSE 80

VOLUME '/var/www/'
VOLUME '/etc/apache2/sites-enabled'
VOLUME '/etc/cron.d/'

RUN apt-get -y install wget ca-certificates
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
