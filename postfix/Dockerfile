FROM ubuntu:latest
RUN apt-get -qq update \
    && apt-get -qq install postfix postfix-mysql

ENV INSTALL_PATH "/mailserver/postfix"
ENV TARGET_PATH "/etc/postfix"

RUN ln -snf /etc/services /var/spool/postfix/etc/services

WORKDIR $TARGET_PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
