FROM ubuntu:latest
RUN apt-get -qq update \
    && apt-get -qq install postfix postfix-mysql

ENV EXPORTED_PATH "/config"
ENV INNER_PATH "/etc/postfix"

RUN mkdir -p ${INNER_PATH}/sql
COPY config/root/* ${INNER_PATH}/
COPY config/sql/* ${INNER_PATH}/sql/

RUN ln -snf /etc/services /var/spool/postfix/etc/services

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
