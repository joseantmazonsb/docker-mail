FROM ubuntu:latest
RUN apt-get -qq update && apt-get -qq install opendkim opendkim-tools

ENV INSTALL_PATH "/mailserver/opendkim"
ENV TARGET_PATH "/etc/opendkim"

RUN mkdir "${TARGET_PATH}/keys"

WORKDIR $TARGET_PATH

ENTRYPOINT ["/docker-entrypoint.sh"]