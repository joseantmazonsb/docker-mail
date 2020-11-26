FROM ubuntu:18.04
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

ENV INSTALL_PATH "/mailserver/vimbadmin"
ENV TARGET_PATH "/var/www/vimbadmin"

RUN a2enmod rewrite ssl env php7.4
COPY apache/000-default.conf /etc/apache2/sites-available
RUN a2ensite 000-default.conf

RUN git clone https://github.com/opensolutions/ViMbAdmin.git $INSTALL_PATH
WORKDIR $INSTALL_PATH
RUN composer install --prefer-dist --no-dev 
RUN chown -R www-data: $INSTALL_PATH/var
COPY .htaccess $INSTALL_PATH/public/
COPY config/application.ini $INSTALL_PATH/application/configs/

WORKDIR $TARGET_PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
