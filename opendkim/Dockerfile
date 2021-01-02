FROM ubuntu:latest
RUN apt-get -qq update && apt-get -qq install opendkim opendkim-tools

ENV EXPORTED_PATH "/config"
ENV INNER_PATH "/etc"

COPY config/opendkim.conf ${INNER_PATH}/

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
