FROM ubuntu:18.04
RUN apt-get -qq update
RUN apt-get -qq install postfix

ENV TMP_PATH "/tmp/postfix"
ENV INSTALL_PATH "/etc/postfix"

COPY ./config/* $TMP_PATH/
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 25 465 587

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD tail -f /dev/null
#CMD postfix start-fg
