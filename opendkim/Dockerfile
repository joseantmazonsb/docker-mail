FROM ubuntu:latest
RUN apt-get -qq update && apt-get -qq install opendkim opendkim-tools

ENV INSTALL_PATH "/mailserver/opendkim"
ENV TARGET_PATH "/etc/opendkim"

RUN mkdir -p "${TARGET_PATH}/keys"

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR $TARGET_PATH

ENTRYPOINT ["/docker-entrypoint.sh"]