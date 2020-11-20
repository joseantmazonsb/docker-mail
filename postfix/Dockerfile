FROM ubuntu:18.04
RUN apt-get -qq update
RUN apt-get -qq install postfix

ENV REAL_PATH "/mailserver/postfix"
ENV INSTALL_PATH "/etc/postfix"

RUN mkdir -p ${REAL_PATH}
RUN mv ${INSTALL_PATH}/* ${REAL_PATH}/
COPY ./config/* $REAL_PATH/
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 25 465 587

ENTRYPOINT ["/docker-entrypoint.sh"]
