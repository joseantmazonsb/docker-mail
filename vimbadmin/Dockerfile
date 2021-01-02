FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq install software-properties-common && \
    apt-add-repository ppa:ondrej/php && apt-get -qq update && \
    apt-get -qq install mcrypt php7.4 php7.4-cgi php7.4-memcache \
    php7.4-json php7.4-mysql libapache2-mod-php7.4 php7.4-mbstring \
    curl memcached git zip unzip php-zip php-xml php-mbstring mysql-client \
    apache2 php7.4-xml dovecot-core
RUN echo "Europe/Madrid" > /etc/timezone    
RUN dpkg-reconfigure -f noninteractive tzdata
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

ENV EXPORTED_PATH "/config"
ENV INNER_PATH "/var/www/vimbadmin"

RUN a2enmod rewrite ssl env php7.4
RUN rm -f /etc/apache2/sites-available/*
COPY apache/vimbadmin.conf /etc/apache2/sites-available
RUN a2ensite vimbadmin.conf

RUN git clone https://github.com/opensolutions/ViMbAdmin.git $INNER_PATH
WORKDIR $INNER_PATH
COPY config/public/* public/
COPY config/application/configs/* application/configs/
RUN composer install --prefer-dist --no-dev 

WORKDIR /
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
