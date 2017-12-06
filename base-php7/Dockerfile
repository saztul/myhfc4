FROM ubuntu:xenial

LABEL maintainer="Lutz Selke <ls@hfci.de>"

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
        ruby \
        poppler-utils \
        libgraphicsmagick++-q16-12 \
        libgraphicsmagick-q16-3 \
        sphinxsearch

RUN mkdir -p /var/www/ \
    && a2dissite 000-default \
    && a2dissite default-ssl \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod php7.0 \
    && a2dismod mpm_event \
    && a2enmod mpm_prefork \
    && dpkg -i dumb-init_*.deb \
    && apt-get clean \
    && chown -R www-data:www-data /var/www \
    && rm -f /etc/cron.d/sphinxsearch \
    && a2enmod dbd authz_dbd authn_dbd mpm_prefork \
        alias auth_digest authn_core authn_file \
        authz_core authz_user dav dav_fs setenvif rewrite

ADD apache/www-dir-opts.conf /etc/apache2/conf-enabled/www-dir-opts.conf

WORKDIR /var/www