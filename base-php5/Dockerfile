FROM ubuntu:xenial

LABEL maintainer="Lutz Selke <ls@hfci.de>"

USER root

ENV DEBIAN_FRONTEND noninteractive

# Adding extra repos like php-5.6
ADD ./apt/sources/* /etc/apt/sources.list.d/
ADD ./apt/keys/* /etc/apt/trusted.gpg.d/

# Apache 2 & PHP 5.6
RUN apt update \
    && apt-get -y update \
    && apt-get -y install --no-install-recommends wget ca-certificates \
    && wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
    && apt-get -y install --no-install-recommends \
        mysql-client-5.7 \
        apache2 \
        graphicsmagick \
        imagemagick \
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
        curl \
        unzip \
        language-pack-de \
        wget \
        supervisor \
        xz-utils \
        libaprutil1-dbd-mysql \
        ghostscript \
        xpdf \
        poppler-utils \
        graphicsmagick \
        libgraphicsmagick++-q16-12 \
        libgraphicsmagick-q16-3 \
        sphinxsearch

RUN mkdir -p /var/www/ \
    && a2dissite 000-default \
    && a2dissite default-ssl \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod php5.6 \
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
