FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq install software-properties-common && apt-add-repository ppa:ondrej/php && apt-get -qq update && \
    apt-get -qq install mcrypt php7.3 php7.3-cgi php7.3-memcache \
    php7.3-json php7.3-mysql libapache2-mod-php7.3 php7.3-mbstring \
    curl memcached git zip unzip php-zip php-xml php-mbstring mysql-client apache2 php7.3-xml
RUN echo "Europe/Dublin" > /etc/timezone    
RUN dpkg-reconfigure -f noninteractive tzdata
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

ENV TMP_PATH "/tmp/vimbadmin"
ENV INSTALL_PATH "/var/www/vimbadmin"

RUN git clone https://github.com/opensolutions/ViMbAdmin.git $TMP_PATH
WORKDIR $TMP_PATH
RUN composer install --prefer-dist --no-dev 
WORKDIR /
RUN chown -R www-data: $TMP_PATH/var

RUN a2enmod rewrite ssl env php7.3
COPY apache/000-default.conf /etc/apache2/sites-available
RUN a2ensite 000-default.conf
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
COPY config/application.ini $TMP_PATH/application/configs/application.ini
WORKDIR $INSTALL_PATH

EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD apachectl -DFOREGROUND