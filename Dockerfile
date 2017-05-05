FROM ubuntu:xenial

MAINTAINER Lutz Selke <ls@hfci.de>

# VSFTP based on https://github.com/helderco/docker-vsftpd

USER root

ENV DEBIAN_FRONTEND noninteractive

# Adding extra repos like php-5.6
ADD ./extras/apt/sources/* /etc/apt/sources.list.d/
ADD ./extras/apt/keys/* /etc/apt/trusted.gpg.d/
ADD ./extras/runner.sh /usr/bin/runner.sh
ADD ./extras/supervisor.conf /etc/supervisord.conf
ADD ./extras/php/* /etc/php/5.6/apache2/conf.d/

# Apache 2 & PHP 5.6
RUN apt update \
    && apt-get -y update \
    && apt-get -y install --no-install-recommends \
        wget \
    && wget --no-check-certificate https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
    && wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && apt-get -y install --no-install-recommends \
        vsftpd \
        db5.3-util \
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
        ssmtp \
        wkhtmltopdf \
        pdftk \
        xvfb \
        cron \
        unzip \
        language-pack-de \
        wget \
        supervisor \
        libaprutil1-dbd-mysql \
    && sed -i '/de_DE/s/^# //' /etc/locale.gen \
    && dpkg-reconfigure locales \
    && mkdir -p /var/www/ \
    && a2dissite 000-default \
    && a2dissite default-ssl \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod php5.6 \
    && a2dismod mpm_event \
    && a2enmod mpm_prefork \
    && dpkg -i dumb-init_*.deb \
    && apt-get -y install xz-utils \
    && tar xvf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && mkdir -p /opt/bin \
    && mv wkhtmltox/bin/wkhtmlto* /opt/bin/ \
    && chmod +x /usr/bin/runner.sh \
    && apt-get clean \
    && mkdir -p /var/run/vsftpd/empty \
    && mkdir -p /etc/vsftpd \
    && mkdir -p /var/ftp \
    && mkdir -p /var/run/vsftpd/empty \
    && chown 444 /var/run/vsftpd/empty \
    && chown -R www-data:www-data /var/www \
    && a2enmod dbd authz_dbd authn_dbd mpm_prefork \
        alias auth_digest authn_core authn_file \
        authz_core authz_user dav dav_fs setenvif rewrite

ADD ./extras/vsftpd/vsftpd.conf /etc/
ADD ./extras/vsftpd/vsftpd.virtual /etc/pam.d/

EXPOSE 21 20
EXPOSE 12020 12021 12022 12023 12024 12025
EXPOSE 80

VOLUME "/var/ftp"
VOLUME '/var/www/'
VOLUME '/etc/apache2/sites-enabled'
VOLUME '/etc/cron.d/'

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
